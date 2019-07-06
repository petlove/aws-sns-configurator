# frozen_string_literal: true

require 'yaml'
require 'erb'

module AWS
  module SNS
    module Configurator
      class Reader
        class WithoutContentError < StandardError; end

        PATH = './config/aws-sns-configurator.yml'

        attr_accessor :config

        def initialize
          build_config!(JSON.parse(read_file!.to_json, symbolize_names: true))
        end

        def topics!
          @config[:topics].map(&method(:build_topic!))
        end

        private

        def read_file!
          YAML.safe_load(ERB.new(File.read(PATH)).result).tap(&method(:handle_options!))
        rescue Errno::ENOENT, WithoutContentError
          { topics: [] }
        end

        def handle_options!(options)
          raise WithoutContentError unless options

          options['topics'] = [] unless options['topics']
        end

        def build_config!(value = { topics: [] })
          @config = value
        end

        def default_config
          @default_config ||= @config.slice(:region, :prefix, :suffix, :environment)
        end

        def build_topic!(options)
          Topic.new(default_config.merge(options))
        end
      end
    end
  end
end
