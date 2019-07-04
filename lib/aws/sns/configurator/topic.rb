# frozen_string_literal: true

module AWS
  module SNS
    module Configurator
      class Topic
        class RequiredFieldError < StandardError; end

        attr_accessor :name, :region, :prefix, :suffix, :environment, :metadata, :name_formatted, :arn

        REQUIRED_ACCESSORS = %i[name region].freeze

        def initialize(options)
          options = normalize(options)

          @name = options[:name]
          @region = options[:region]
          @prefix = options[:prefix]
          @suffix = options[:suffix]
          @environment = options[:environment]
          @metadata = options[:metadata]
          build_name_formatted!
          build_arn!

          validate!
        end

        def create!(client = default_client)
          client.aws.create_topic(name: @name_formatted)
        end

        def find!(client = default_client)
          client.aws.get_topic_attributes(topic_arn: @arn)
        rescue Aws::SNS::Errors::NotFound, Aws::SNS::Errors::InvalidClientTokenId
          false
        end

        def subscribe!(protocol, endpoint, options)
          subscription = default_client.aws.subscribe(topic_arn: @arn, protocol: protocol, endpoint: endpoint)
          return unless subscription

          attributes = options[:attributes].to_a
          attributes << raw_attribute if options[:raw]
          attributes.each { |a| subscription_attributes!(subscription, a) }
          subscription
        end

        def publish!(message)
          default_client.aws.publish(topic_arn: @arn, message: message.to_json)
        end

        private

        def normalize(options)
          return default_options(options) if options.is_a?(String)

          default_options.merge(options.compact)
        end

        def default_options(name = nil)
          { name: name, region: ENV['AWS_REGION'], metadata: {} }
        end

        def default_client
          @default_client ||= Client.new(@region)
        end

        def raw_attribute
          { attribute_name: 'RawMessageDelivery', attribute_value: 'true' }
        end

        def subscription_attributes!(subscription, attributes)
          default_client.aws
                        .set_subscription_attributes(attributes.merge(subscription_arn: subscription.subscription_arn))
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
