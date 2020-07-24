# frozen_string_literal: true

module StoredSafe
  module Config
    ##
    # Set up fields needed for configuration of StoredSafe connection.
    module Configurable
      attr_accessor(
        :host, :token, :ca_bundle, :skip_verify,
        :config_sources, :apikey, :version, :parser
      )
    end
  end
end
