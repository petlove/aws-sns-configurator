# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws/sns/configurator/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws-sns-configurator'
  spec.version       = AWS::SNS::Configurator::VERSION
  spec.authors       = ['linqueta']
  spec.email         = ['tecnologia@petlove.com.br']

  spec.licenses      = ['MIT']
  spec.summary       = 'Simple configurator for AWS SNS services'
  spec.description   = 'Simple configurator for AWS SNS services'
  spec.homepage      = 'https://github.com/petlove/aws-sns-configurator'

  spec.files         = Dir['{lib}/**/*', 'CHANGELOG.md', 'MIT-LICENSE', 'README.md']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'aws-sdk-core', '~> 3'
  spec.add_dependency 'aws-sdk-sns', '>= 1.18.0'

  spec.add_development_dependency 'bundler', '~> 2.1.0'
  spec.add_development_dependency 'rake', '~> 13.0'

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'hashdiff', '>= 1.0.0.beta1', '< 2.0.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'simplecov-summary'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
