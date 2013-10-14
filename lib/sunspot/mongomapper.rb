require 'sunspot'
require 'mongo_mapper'
require 'sunspot/rails'
require 'yaml'
require 'reindex'
require 'sidekiq'

# == Examples:
#
# class Post
#   include MongoMapper::Document
#   field :title
#
#   include Sunspot::MongoMapper
#   searchable do
#     text :title
#   end
# end
#

IS_IN_TEST = Rails.env == "test"

module Sunspot
  module MongoMapper
    atomic_methods = %w(increment decrement set unset push push_all add_to_set push_uniq pull pull_all pop)
    atomic_methods.each do |m|
      define_method(m) do |*args|
        super *args
        self.index_later
      end
    end

    def index_later
      if IS_IN_TEST
        Reindex.new.index_synchronous(self)
      else
        Reindex.perform_async(self.id, self.class.to_s)
      end
    end

    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        extend Sunspot::MongoMapper::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
        after_destroy :_remove_index
        after_save :index_later
      end
    end

    module ActsAsMethods
      # ClassMethods isn't loaded until searchable is called so we need
      # call it, then extend our own ClassMethods.
      def searchable (opt = {}, &block)
        super
        extend ClassMethods
      end
    end

    module ClassMethods
      # The sunspot solr_index method is very dependent on ActiveRecord, so
      # we'll change it to work more efficiently with Mongoid.
      def solr_index(opt={})
        Sunspot.index!(all)
      end

      def solr_index_orphans(opts={})
        batch_size = opts[:batch_size] || Sunspot.config.indexing.default_batch_size
        
        page = 0
        orphaned_ids = []
        while (page = page.next)
          ids = search { paginate(:page => page, :per_page => batch_size) }.hits.collect { |h| h.primary_key }
          break if ids.empty?
          ids.each do |id|
            orphaned_ids << id unless find(id)
          end
        end

        return orphaned_ids
      end

      def solr_clean_index_orphans(opts={})
        solr_index_orphans(opts).each do |id|
          new(id: BSON::ObjectId(id)).solr_remove_from_index
        end
      end
    end


    class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id.to_s
      end
    end

    class DataAccessor < Sunspot::Adapters::DataAccessor
      def load(id)
        find(id).first
      end

      def load_all(ids)
        find(ids)
      end

      private

      def find(id)
        @clazz.find(id)
      end
    end

    def _remove_index
      Sunspot.remove! self
    end
  end
end
