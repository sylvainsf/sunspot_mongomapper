sunspot_mongomapper
====

A Sunspot wrapper for MongoMapper

Install
----

    gem install sunspot_mongomapper

Examples
----

    class Post
      include MongoMapper::Document
      field :title

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

Copyright
----

Copyright (c) 2012 sylvainsf. See LICENSE for details.
