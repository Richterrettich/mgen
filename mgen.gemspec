# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mgen/version'

Gem::Specification.new do |spec|
  spec.name          = "mgen"
  spec.version       = Mgen::VERSION
  spec.authors       = ["Rene Richter"]
  spec.email         = ["Richterrettich@gmail.com"]

  spec.summary       = %q{Generator for spring microservices}
  spec.description   = %q{Generator for spring microservices}
  spec.homepage      = "https://github.com/Richterrettich/mgen"
  spec.license = "GPLv3"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = "mgen"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'git', '~> 1.2.9.1'
end
