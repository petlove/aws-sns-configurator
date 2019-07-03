# frozen_string_literal: true

module AWS
  module SNS
    module Configurator
      class Creator
        attr_accessor :topics, :force, :created, :found

        def initialize(force = false)
          clear!
          @force = force
          @topics = Reader.new.topics!
        end

        def create!
          tap { topics_by_region.each { |region_topics| create_by_region(*region_topics) } }
        end

        private

        def topics_by_region
          @topics.group_by(&:region)
        end

        def create_by_region(region, topics)
          client = Client.new(region)

          topics.each { |topic| create_topic(topic, client) if @force || !find_topic(topic, client) }
        end

        def find_topic(topic, client)
          topic.find!(client).tap do |found|
            if found
              add_found(topic)
              Logger.info("Found: #{topic.name_formatted} - #{topic.region}")
            end
          end
        end

        def create_topic(topic, client)
          add_created(topic.create!(client))
          Logger.info("Created: #{topic.name_formatted} - #{topic.region}")
        end

        def clear!
          @created = []
          @found   = []
        end

        def add_created(topic)
          @created << topic
        end

        def add_found(topic)
          @found << topic
        end
      end
    end
  end
end