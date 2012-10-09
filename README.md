sunspot_mongomapper
====

A Sunspot wrapper for MongoMapper based on the excellent wrapper for Mongoid written by jugyo.

Special thanks to @peterlind for submitting some crucial fixes to Sunspot Mongoid that I was able to adapt for Sunspot MongoMapper.

Install
----

    gem install sunspot_mongomapper

The sunspot gem currently has an issue with loading the config/sunspot.yml, for now you can work around it by creating an initializer.
    config/initializers/sunspot.rb

    require 'sunspot'
    require 'mongo_mapper'
    require 'sunspot/rails'
    require 'yaml'

    # Override the sunspot url since the yml doesn't work.
    sunspot_config = YAML.load_file("#{Rails.root}/config/sunspot.yml")
    Sunspot.config.solr.url = "http://#{sunspot_config[Rails.env]["solr"]["hostname"]}:#{sunspot_config[Rails.env]["solr"]["port"]}/solr"

Then you just need a sunspot.yml to configure your environments like so:

    production:
      solr:
        hostname: localhost
        port: 8080
        log_level: WARNING
        # read_timeout: 2
        # open_timeout: 0.5
    development:
      solr:
        hostname: localhost
        port: 8983
        log_level: INFO
    test:
      solr:
        hostname: localhost
        port: 8981
        log_level: WARNING

Examples
----

    class Post
      include MongoMapper::Document
      key :title, String

      include Sunspot::MongoMapper
      searchable do
        text :title
      end
    end

For Rails3
----

### as gem:

add a gem to Gemfile as following,

    gem 'sunspot_mongomapper'

### as plugin:

add gems to Gemfile as following,

    gem 'sunspot'
    gem 'sunspot_rails'

and install sunspot_mongoid as rails plugin,

    rails plugin install git://github.com/sylvainsf/sunspot_mongomapper.git

Links
----

* [sunspot](http://github.com/outoftime/sunspot)
* [sunspot_rails](http://github.com/outoftime/sunspot/tree/master/sunspot_rails/)
* [sunspot_mongoid](http://github.com/jugyo/sunspot_mongoid/)

Copyright
----

Copyright (c) 2012 sylvainsf. See LICENSE for details.
