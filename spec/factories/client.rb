# frozen_string_literal: true

FactoryBot.define do
  factory :client, class: AWS::SNS::Configurator::Client do
    initialize_with { new('us-east-1') }
  end
end
