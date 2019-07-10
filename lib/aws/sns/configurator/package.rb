# frozen_string_literal: true

require 'ruby/utils'

module AWS
  module SNS
    module Configurator
      class Package
        include ::Ruby::Utils

        GENERAL_DEFAULT_OPTIONS = %i[region prefix suffix environment metadata].freeze
        GENERAL_DEFAULT_PATH = %i[default general].freeze
        TOPIC_DEFAULT_PATH = %i[default topic].freeze
        DEFAULT_CONTENT = { topics: [] }.freeze

        attr_accessor :content, :topics_options, :general_default_options, :topic_default_options

        def initialize(content)
          build_content!(content)
          build_topics_options!
          build_general_default_options!
          build_topic_default_options!
        end

        def unpack!
          @topics_options.map(&method(:build_topic!))
        end

        private

        def build_content!(content)
          @content = DEFAULT_CONTENT.merge(content || {})
        end

        def build_topics_options!
          @topics_options = @content[:topics]
        end

        def build_general_default_options!
          @general_default_options = default_options(GENERAL_DEFAULT_PATH, GENERAL_DEFAULT_OPTIONS)
        end

        def build_topic_default_options!
          @topic_default_options = default_options(TOPIC_DEFAULT_PATH, GENERAL_DEFAULT_OPTIONS)
        end

        def default_options(path, fields)
          slice(dig(@content, path, {}), fields)
        end

        def build_topic!(topic_options)
          Topic.new(build_topic_options(topic_options))
        end

        def build_topic_options(topic_options)
          general_default_options.merge(topic_default_options).merge(hash_compact(topic_options))
        end
      end
    end
  end
end
