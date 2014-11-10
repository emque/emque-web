# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emque/web/version'

Gem::Specification.new do |spec|
  spec.name          = "emque-web"
  spec.version       = Emque::Web::VERSION
  spec.authors       = ["Dan Matthews"]
  spec.email         = ["dev@teamsnap.com"]
  spec.summary       = %q{A simple web interface for emque administration}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oj", "~> 2.10.2"
  spec.add_dependency "faraday", "~> 0.9"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
