# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wrapit/version'

Gem::Specification.new do |spec|
  spec.name          = "wrapit"
  spec.version       = Wrapit::VERSION
  spec.authors       = ["JD Guzman"]
  spec.email         = ["jdguzman@mac.com"]
  spec.description   = %q{Wrap attributes of any class to explicitly avoid nils.}
  spec.summary       = %q{This gem allows you to define attribtues that need to be wrapped, or wrap already defined attributes.}
  spec.homepage      = "https://github.com/jdguzman/wrapit"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "wrapped", "~> 0.0.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
