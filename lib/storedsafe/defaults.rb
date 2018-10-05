module Storedsafe
  ##
  # Provides default values for Configurable parameters
  ##
  module Defaults
    require_relative 'defaults/rc'
    class << self
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
        ENV['SKIP_VERIFY']
      end

      def use_rc
        true
      end

      def rc_path
        File.join(Dir.home, '.storedsafe-client.rc')
      end

      def use_env
        true
      end

      def username
        nil
      end

      def passphrase
        nil
      end

      def hotp
        nil
      end

      def totp
        nil
      end

      def api_key
        nil
      end
    end
  end
end
