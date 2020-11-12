# frozen_string_literal: true

require 'bundler/setup'
require 'aws/sns/configurator'

namespace :aws do
  namespace :sns do
    desc 'Create topics by config (./config/aws-sns-configurator.yml)'
    task :create, [:force] do |_t, args|
      AWS::SNS::Configurator.create!(force: args[:force] == 'force')
    end
  end
end
