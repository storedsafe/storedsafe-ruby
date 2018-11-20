# frozen_string_literal: true

##
# Ruby wrapper for the Storedsafe RESTlike API.
module Storedsafe
  class << self
    require_relative 'storedsafe/api'
    require_relative 'storedsafe/configurable'
    require_relative 'storedsafe/defaults'

    ##
    # Set up a new APIHandler instance configured to communicate
    # with your Storedsafe server.
    # @see Storedsafe::Configurable for more information about
    #   the available fields for configuration.
    def configure
      API::APIHandler.new do |api|
        yield api
      end
    end
  end
end
