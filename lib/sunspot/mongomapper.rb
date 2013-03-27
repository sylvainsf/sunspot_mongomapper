require 'sunspot'
require 'mongo_mapper'
require 'sunspot/rails'
require 'yaml'
require 'reindex'
require 'resque'


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
      Resque.enqueue(Reindex, self.id, self.class.to_s)
    end

    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        extend Sunspot::MongoMapper::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
        after_destroy :_remove_index
        after_save :_update_index


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

        solr_page = 0
        solr_ids = []
        while (solr_page = solr_page.next)
          ids = solr_search_ids { paginate(:page => solr_page, :per_page => 1000) }.to_a
          break if ids.empty?
          solr_ids.concat ids
        end

        return solr_ids - self.all.collect { |c| c.id.to_s }
      end

      def solr_clean_index_orphans(opts={})
        solr_index_orphans(opts).each do |id|
          new do |fake_instance|
            fake_instance.id = id
          end.solr_remove_from_index
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

    def _update_index
      Sunspot.index! self
      Sunspot.commit_if_dirty
    end
  end
end
