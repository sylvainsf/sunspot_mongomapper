# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sunspot_mongomapper"
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["sylvainsf"]
  s.date = "2012-10-09"
  s.description = "A Sunspot wrapper for MongoMapper that is like sunspot_rails."
  s.email = "sylvain.niles@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "examples/example.rb",
    "init.rb",
    "lib/reindex.rb",
    "lib/sunspot/mongomapper.rb",
    "lib/sunspot/mongomapper/railtie.rb",
    "lib/sunspot_mongomapper.rb",
    "sunspot_mongomapper.gemspec",
    "tasks/sunspot_mongomapper.rake",
    "test/helper.rb",
    "test/test_sunspot_mongomapper.rb"
  ]
  s.homepage = "http://github.com/sylvainsf/sunspot_mongomapper"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A Sunspot wrapper for MongoMapper."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sunspot_mongomapper>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_runtime_dependency(%q<sunspot>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<sunspot_rails>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<resque>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<sunspot_mongomapper>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_dependency(%q<sunspot>, [">= 1.1.0"])
      s.add_dependency(%q<sunspot_rails>, [">= 1.1.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<sunspot_mongomapper>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<mongo_mapper>, [">= 0"])
    s.add_dependency(%q<sunspot>, [">= 1.1.0"])
    s.add_dependency(%q<sunspot_rails>, [">= 1.1.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end

