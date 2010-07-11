require 'rubygems'
require 'rake'

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "seess/version"

Gem::Specification.new do |s|
  s.name        = "seess"
  s.version     = SeeSS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bryan Tomlin"]
  s.email       = ["btomlin@gmail.com"]
  s.homepage    = "http://github.com/bdtomlin/SeeSS"
  s.summary     = "SeeSS is a base css template mostly taken from sencss (http://sencss.kilianvalkhof.com/)"
  s.description = "SeeSS is a base css template mostly taken from sencss (http://sencss.kilianvalkhof.com/)"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "SeeSS"

  s.add_runtime_dependency("haml", [">=3.0.13"])

  s.add_development_dependency(%q<rspec>, [">=2.0.0.beta.17"])

  s.files        = FileList["lib/**/*","public/stylesheets/seess/*"].to_a
  s.require_path = 'lib'
  s.executables = ['seess']
end

