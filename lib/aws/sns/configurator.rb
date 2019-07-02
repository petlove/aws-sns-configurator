# frozen_string_literal: true

require 'aws/sns/configurator/version'
require 'aws/sns/configurator/topic'
require 'aws/sns/configurator/reader'
require 'aws-sdk-sns'

module AWS
  module SNS
    module Configurator
      class Error < StandardError; end
    end
  end
end
