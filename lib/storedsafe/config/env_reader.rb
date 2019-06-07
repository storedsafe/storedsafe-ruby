# frozen_string_literal: true

module Storedsafe
  module Config
    ##
    # Reads configuration items from environment variables.
    class EnvReader
      attr_reader :config

      ##
      # Read configuration from environment variables.
      # @param [Hash] fields Mapping from configuration field to environment
      #   variable name.
      def initialize(fields = {
        server: 'STOREDSAFE_SERVER',
        token: 'STOREDSAFE_TOKEN',
        ca_bundle: 'STOREDSAFE_CABUNDLE',
        skip_verify: 'STOREDSAFE_SKIP_VERIFY'
      })
        @fields = fields
        @config = {}
      end

      ##
      # Read values from file into the @config hash.
      def read
        @fields.each do |key, val|
          @config[key] = ENV[val]
        end
        @config
      end
    end
  end
end
