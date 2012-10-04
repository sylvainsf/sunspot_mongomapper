require 'sunspot/mongomapper'
require 'rails'

module Sunspot::MongoMapper
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../../../../tasks/sunspot_mongomapper.rake", __FILE__)
    end
  end
end
