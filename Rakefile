require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "ffi-opengl-dsl"
    gem.summary = "DSL for ffi-opengl"
    gem.files = Dir["{lib}/**/*"]
    gem.authors = "Tymon Tobolski"
    # other fields that would normally go in your gemspec
    # like authors, email and has_rdoc can also be included here
  end
rescue
  puts "Jeweler or one of its dependencies is not installed."
end

desc 'Create doc'
task :doc do
  `yardoc **/*`
end
