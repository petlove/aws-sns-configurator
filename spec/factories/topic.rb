# frozen_string_literal: true

FactoryBot.define do
  factory :topic, class: AWS::SNS::Configurator::Topic do
    initialize_with { new(name: 'update_price', region: 'us-east-1') }

    name { 'update_price' }
    region { 'us-east-1' }
    prefix { 'prices' }
    suffix { 'warning' }
    environment { 'production' }
    tag { 'strict' }
    failures { build :topic, suffix: 'warning_failures', failures: nil }
    name_formatted { 'prices_production_update_price_warning' }
    arn { 'arn:aws:sns:us-east-1:123456789:prices_production_update_price_warning' }
  end
end
