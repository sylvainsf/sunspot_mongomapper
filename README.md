sunspot_mongomapper
====

A Sunspot wrapper for MongoMapper based on the excellent wrapper for Mongoid written by jugyo.

Install
----

    gem install sunspot_mongomapper

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
