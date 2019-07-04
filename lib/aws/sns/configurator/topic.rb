# frozen_string_literal: true

module AWS
  module SNS
    module Configurator
      class Topic
        class RequiredFieldError < StandardError; end

        attr_accessor :name, :region, :prefix, :suffix, :environment, :tag, :name_formatted, :arn

        REQUIRED_ACCESSORS = %i[name region].freeze

        def initialize(options)
          @name = options[:name]
          @region = options[:region]
          @prefix = options[:prefix]
          @suffix = options[:suffix]
          @environment = options[:environment]
          @tag = options[:tag]
          build_name_formatted!
          build_arn!

          validate!
        end

        def create!(client)
          client.aws.create_topic(name: @name_formatted)
        end

        def find!(client)
          client.aws.get_topic_attributes(topic_arn: @arn)
        rescue Aws::SNS::Errors::NotFound, Aws::SNS::Errors::InvalidClientTokenId
          false
        end

        def subscribe!(client, protocol, endpoint, options = {})
          subscription = client.aws.subscribe(topic_arn: @arn, protocol: protocol, endpoint: endpoint)
          return unless subscription

          attributes = options[:attributes].to_a
          attributes << raw_attribute if options[:raw]
          attributes.each { |a| subscription_attributes!(client, subscription, a) }
          subscription
        end

        private

        def raw_attribute
          { attribute_name: 'RawMessageDelivery', attribute_value: 'true' }
        end

        def subscription_attributes!(client, subscription, attributes)
          client.aws.set_subscription_attributes(attributes.merge(subscription_arn: subscription.subscription_arn))
        end

        def account_id
          ENV['AWS_ACCOUNT_ID']
        end

        def validate!
          REQUIRED_ACCESSORS.each do |accessor_name|
            raise RequiredFieldError, "The field #{accessor_name} is required" if send(accessor_name).nil?
          end
        end

        def build_name_formatted!
          @name_formatted = [@prefix, @environment, @name, @suffix].compact.join('_')
        end

        def build_arn!
          @arn = ['arn:aws:sns', @region, account_id, @name_formatted].compact.join(':')
        end
      end
    end
  end
end
