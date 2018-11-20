# frozen_string_literal: true

module Storedsafe
  ##
  # Provides default values for Configurable parameters
  ##
  module Defaults
    require_relative 'defaults/rc'

    # Default RC path.
    RC_PATH = File.join(Dir.home, '.storedsafe-client.rc')

    # Use RC unless otherwise specified.
    USE_RC = true

    # Use environment variables unless otherwise specified.
    USE_ENV = true

    # The version of the Storedsafe API currently being used.
    API_VERSION = '1.0'

    class << self
      ##
      # Allocate uninitialized values in a configurable object with
      # values from environment variables or an RC-file.
      # @param [Storedsafe::Configurable] configurable
      def allocate(configurable)
        configurable.api_version ||= API_VERSION
        configurable.use_env = USE_ENV if configurable.use_env.nil?
        configurable.use_rc = USE_RC if configurable.use_rc.nil?

        allocate_from_env(configurable) if configurable.use_env
        allocate_from_rc(configurable) if configurable.use_rc
      end

      private

      def allocate_from_env(configurable)
        configurable.token ||= token
        configurable.server ||= server
        configurable.ca_bundle ||= ca_bundle
        configurable.skip_verify =
          configurable.skip_verify ||
          (configurable.skip_verify.nil? && skip_verify)
      end

      def allocate_from_rc(configurable)
        rc_path = configurable.rc_path || RC_PATH
        rc = Rc.new(rc_path)
        configurable.token ||= rc.token
        configurable.username ||= rc.username
        configurable.api_key ||= rc.api_key
        configurable.server ||= rc.server
      end

      def server
        ENV['STOREDSAFE_SERVER']
      end

      def token
        ENV['STOREDSAFE_TOKEN']
      end

      def ca_bundle
        ENV['STOREDSAFE_CABUNDLE']
      end

      def skip_verify
        ENV['STOREDSAFE_SKIP_VERIFY']
      end
    end
  end
end
