# frozen_string_literal: true

module Storedsafe
  module Config
    ##
    # Set up fields needed for configuration of Storedsafe connection.
    module Configurable
      attr_accessor(
        :server, :token, :ca_bundle, :skip_verify, :config_sources,
        :username, :api_key, :api_version, :parser
      )
    end
  end
end
