# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/cache/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-cache'
  spec.version       = Grape::Cache::VERSION
  spec.authors       = ['Karl Freeman']
  spec.email         = ['karlfreeman@gmail.com']
  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'grape', '~> 0.3'
  spec.add_runtime_dependency 'rack', '>= 1.3.0'
  spec.add_runtime_dependency 'virtus', '>= 1.0.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'yard'

end


