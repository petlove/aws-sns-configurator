# frozen_string_literal: true

require 'aws/sns/configurator/version'
require 'aws/sns/configurator/logger'
require 'aws/sns/configurator/reader'
require 'aws/sns/configurator/topic'
require 'aws/sns/configurator/client'
require 'aws/sns/configurator/creator'
require 'aws/sns/configurator/subscriber'
require 'aws-sdk-sns'

module AWS
  module SNS
    module Configurator
      require 'aws/sns/configurator/railtie' if defined?(Rails)

      class << self
        def create!(force = false)
          Creator.new(force).create!
        end

        def subscribe!(topic, protocol, endpoint, options = {})
          Subscriber.new(topic, protocol, endpoint, options).subscribe!
        end

        def read!
          Reader.new.topics!
        end
      end
    end
  end
end
