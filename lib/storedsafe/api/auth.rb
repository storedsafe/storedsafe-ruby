# frozen_string_literal: true

module Storedsafe
  ##
  # Handles API requests to the /auth path.
  class API
    ##
    # Authenticates a user with a Yubico OTP.
    # @param [String] passphrase
    # @param [String] otp Yubikey press
    # @see authenticate Authentication with other OTP types.
    def authenticate_yubikey(passphrase, otp)
      data = request(
        :post, '/auth',
        username: @username, keys: "#{passphrase}#{@api_key}#{otp}"
      )
      @token = data['CALLINFO']['token']
      data
    end

    ##
    # Authenticates a user with specified OTP method.
    # @param [String] passphrase
    # @param [String] otp One-time password
    # @param [String] logintype See Storedsafe::API::LoginType
    def authenticate(passphrase, otp, logintype = LoginType::TOTP)
      if logintype == LoginType::YUBIKEY
        return authenticate_yubikey(passphrase, otp)
      end

      data = request(
        :post, '/auth',
        username: @username, passphrase: passphrase, otp: otp,
        apikey: @api_key, logintype: logintype
      )
      @token = data['CALLINFO']['token']
      data
    end

    ##
    # Invalidates the token.
    def logout
      data = request(:get, '/auth/logout', token: @token)
      @token = nil if data['CALLINFO']['status'] == 'SUCCESS'
      data
    end

    ##
    # Checks whether or not the token is valid and refreshes the
    # timeout for that token if valid.
    def check
      request(:get, '/auth/check', token: @token)
    end
  end
end
