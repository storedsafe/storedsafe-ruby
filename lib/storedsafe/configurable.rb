module Storedsafe
  ##
  # Set up fields needed for configuration of Storedsafe connection.
  ##
  module Configurable
    def self.keys # rubocop:disable Metrics/MethodLength
      @keys = %i[
        server
        token
        ca_bundle
        skip_verify
        use_rc
        rc_path
        use_env
        username
        passphrase
        hotp
        totp
        api_key
      ]
    end

    Storedsafe::Configurable.keys.each(&method(:attr_accessor))
  end
end
