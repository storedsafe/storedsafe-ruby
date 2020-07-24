# frozen_string_literal: true

require 'storedsafe/api'
require 'storedsafe/config'
require 'storedsafe/parser'

##
# Ruby wrapper for the StoredSafe RESTlike API.
module StoredSafe
  VERSION = '0.1.0'

  class << self
    ##
    # Set up a new API instance configured to communicate with your StoredSafe
    # server.
    # @see StoredSafe::Config::Configurable for more information about the
    #   available fields for configuration.
    def configure
      API.new do |api|
        yield api if block_given?
      end
    end
  end
end
