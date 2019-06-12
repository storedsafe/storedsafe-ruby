# frozen_string_literal: true

module Storedsafe
  module Config
    ##
    # Reads configuration items from environment variables.
    module EnvReader
      class << self
        ##
        # Parses the passed environment variable names into a hash of config
        #   values.
        # @param [Hash] fields Mapping from configuration field to environment
        #   variable name.
        def parse_env(fields = {
          server: 'STOREDSAFE_SERVER',
          token: 'STOREDSAFE_TOKEN',
          ca_bundle: 'STOREDSAFE_CABUNDLE',
          skip_verify: 'STOREDSAFE_SKIP_VERIFY'
        })
          config = {}
          fields.each do |key, val|
            config[key] = ENV[val]
          end
          config
        end
      end
    end
  end
end
