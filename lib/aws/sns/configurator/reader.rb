# frozen_string_literal: true

require 'yaml'

module AWS
  module SNS
    module Configurator
      class Reader
        class WithoutContentError < StandardError; end

        PATH = './config/aws-sns-configurator.yml'

        attr_accessor :config

        def initialize
          options = symbolize(read_file!)
          options[:topics] = options[:topics] ? options[:topics].map { |topic| symbolize(topic) } : []
          build_config!(options)
        end

        def topics!
          @config[:topics].map(&method(:build_topic!)).flatten
        end

        private

        def read_file!
          YAML.safe_load(File.read(PATH)).tap { |options| raise WithoutContentError unless options }
        rescue Errno::ENOENT, WithoutContentError
          { topics: [] }
        end

        def symbolize(object)
          object.each_with_object({}) { |(k, v), memo| memo[k.to_sym] = v }
        end

        def build_config!(value = { topics: [] })
          @config = value
        end

        def default_config
          @default_config ||= @config.slice(:region, :prefix, :suffix, :environment, :failures)
        end

        def build_topic!(options)
          topic = Topic.new(default_config.merge(options))
          [topic, topic.failures].compact
        end
      end
    end
  end
end
