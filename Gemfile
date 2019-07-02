# frozen_string_literal: true

source 'https://rubygems.org'

gem 'aws-sdk-sns', '~> 1.18.0'

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :test do
  gem 'factory_bot'
  gem 'hashdiff', ['>= 1.0.0.beta1', '< 2.0.0']
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'simplecov-console'
  gem 'simplecov-summary'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

gemspec
