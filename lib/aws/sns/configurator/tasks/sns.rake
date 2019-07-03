# frozen_string_literal: true

require 'aws/sns/configurator'

namespace :sns do
  desc 'Create topics by config (./config/aws-sns-configurator.yml)'
  task :create do
    options = ARGV[1..-1]
    force = options.find { |option| ['force'].include?(option) }

    AWS::SNS::Configurator.create!(force)
  end
end
