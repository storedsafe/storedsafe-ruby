module Storedsafe
  ##
  # Provides default values for Configurable parameters
  ##
  module Defaults
    require_relative 'defaults/rc'

    RC_PATH = File.join(Dir.home, '.storedsafe-client.rc')
    USE_RC = true
    USE_ENV = true

    class << self
      def allocate(configurable)
        if configurable.use_env ||
            (configurable.use_env.nil? && USE_ENV)
          configurable.token ||= token
          configurable.server ||= server
          configurable.ca_bundle ||= ca_bundle
          configurable.skip_verify =
            configurable.skip_verify ||
            (configurable.skip_verify.nil? && skip_verify)
        end

        if configurable.use_rc ||
            (configurable.use_rc.nil? && USE_RC)
          rc_path = configurable.rc_path || RC_PATH
          rc = Rc.new(rc_path)
          configurable.token ||= rc.token
          configurable.username ||= rc.username
          configurable.api_key ||= rc.api_key
          configurable.server ||= rc.server
        end
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
