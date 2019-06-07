# frozen_string_literal: true

##
# Ruby wrapper for the Storedsafe RESTlike API.
module Storedsafe
  class << self
    require 'storedsafe/api'
    require 'storedsafe/config'
    require 'storedsafe/parser'

    ##
    # Set up a new API instance configured to communicate with your Storedsafe
    # server.
    # @see Storedsafe::Config::Configurable for more information about the
    #   available fields for configuration.
    def configure
      API.new do |api|
        yield api if block_given?
      end
    end
  end
end
