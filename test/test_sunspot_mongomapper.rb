require 'helper'

#
# NOTE: I think tests are too few...
#
class TestSunspotMongoMapper < Test::Unit::TestCase
  class Foo
    include MongoMapper::Document
    field :title

    include Sunspot::MongoMapper
    searchable do
      text :title
    end
  end

  class Bar
    include MongoMapper::Document
    field :title

    include Sunspot::MongoMapper
    searchable(:auto_index => false, :auto_remove => false) do
      text :title
    end
  end

  context 'default' do
    should 'sunspot_options is specified' do
      assert Foo.sunspot_options == {:include => []}
      assert Bar.sunspot_options == {:auto_index=>false, :auto_remove=>false, :include=>[]}
    end
    
    should 'not allow re-enqueue of duplicate' do
      f = Foo.new
      assert f.index_later
      assert_equal f.index_later,nil
    end

    should 'be called Sunspot.setup when call Foo.searchable' do
      mock(Sunspot).setup(Foo)
      Foo.searchable
    end

    should 'get as text_fields from Sunspot::Setup' do
      text_field = Sunspot::Setup.for(Foo).all_text_fields.first
      assert text_field.type == Sunspot::Type::TextType.instance
      assert text_field.name == :title
    end

    should 'search' do
      options = {}
      mock.proxy(Foo).solr_execute_search(options)
      mock(Sunspot).new_search(Foo) { mock(Object.new).execute }
      Foo.search(options)
    end
  end
end
