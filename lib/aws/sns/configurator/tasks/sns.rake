# frozen_string_literal: true

require 'aws/sns/configurator'

namespace :sns do
  desc 'Create topics by config (./config/aws-sns-configurator.yml)'
  task :create[:force] do |_t, args|
    AWS::SNS::Configurator.create!(args[:force] == 'force')
  end
end
