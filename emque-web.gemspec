# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "emque-web"
  spec.version       = "0.0.1"
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
  spec.required_ruby_version = "~> 2.1.2"

  spec.add_dependency "oj",      "~> 2.11.4"
  spec.add_dependency "faraday", "~> 0.9"

  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
