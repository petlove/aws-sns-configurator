# frozen_string_literal: true

require 'aws/sns/configurator/version'
require 'aws/sns/configurator/logger'
require 'aws/sns/configurator/reader'
require 'aws/sns/configurator/topic'
require 'aws/sns/configurator/client'
require 'aws/sns/configurator/creator'
require 'aws-sdk-sns'

module AWS
  module SNS
    module Configurator
      class << self
        def create!(force = false)
          Creator.new(force).create!
        end
      end
    end
  end
end
