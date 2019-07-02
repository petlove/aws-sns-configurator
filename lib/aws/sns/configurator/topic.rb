# frozen_string_literal: true

module AWS
  module SNS
    module Configurator
      class Topic
        class RequiredFieldError < StandardError; end

        attr_accessor :name, :region, :prefix, :suffix, :environment, :tag, :name_formatted, :arn, :failures

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
          build_failures!(options)
        end

        private

        def validate!
          REQUIRED_ACCESSORS.each do |accessor_name|
            raise RequiredFieldError, "The field #{accessor_name} is required" if send(accessor_name).nil?
          end
        end

        def build_failures!(options)
          return unless options[:failures]

          @failures = self.class.new(options.merge(failures: false, suffix: [@suffix, 'failures'].compact.join('_')))
        end

        def build_name_formatted!
          @name_formatted = [@prefix, @environment, @name, @suffix].compact.join('_')
        end

        def build_arn!
          @arn = ['arn:aws:sns', @region, ENV['AWS_ACCOUNT_ID'], @name_formatted].compact.join(':')
        end
      end
    end
  end
end
