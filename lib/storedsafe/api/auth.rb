# frozen_string_literal: true

module StoredSafe
  ##
  # Handles API requests to the /auth path.
  class API
    ##
    # Authenticates a user with a Yubico OTP.
    # @param [String] username
    # @param [String] passphrase
    # @param [String] otp Yubikey press
    # @see authenticate Authentication with other OTP types.
    def login_yubikey(username, passphrase, otp)
      data = request_auth(
        username: username,
        keys: "#{passphrase}#{@apikey}#{otp}"
      )
      @token = data['CALLINFO']['token']
      data
    end

    ##
    # Authenticates a user using TOTP.
    # @param [String] username
    # @param [String] passphrase
    # @param [String] otp One-time password
    def login_totp(username, passphrase, otp)
      data = request_auth(
        username: username,
        passphrase: passphrase,
        otp: otp,
        logintype: 'totp'
      )
      @token = data['CALLINFO']['token']
      data
    end

    ##
    # Invalidates the token.
    def logout
      data = request_get('/auth/logout')
      @token = nil if data['CALLINFO']['status'] == 'SUCCESS'
      data
    end

    ##
    # Checks whether or not the token is valid and refreshes the
    # timeout for that token if valid.
    def check
      request_get('/auth/check')
    end
  end
end
