# frozen_string_literal: true

module Storedsafe
  ##
  # Handles API requests to the /auth path.
  class API
    ##
    # Authenticates a user with a Yubico OTP.
    # @see authenticate_otp Authentication with other OTP types.
    def authenticate_yubikey(passphrase, otp)
      res = request(
        :post, '/auth',
        username: @username, keys: "#{passphrase}#{@api_key}#{otp}"
      )
      data = parse_body(res)
      @token = data['CALLINFO']['token']
      data
    end

    ##
    # Authenticates a user with specified OTP method.
    def authenticate(passphrase, otp, logintype = AUTH_TOTP)
      return authenticate_yubikey(passphrase, otp) if logintype == AUTH_YUBIKEY
      res = request(
        :post, '/auth',
        username: @username, passphrase: passphrase, otp: otp,
        apikey: @api_key, logintype: logintype
      )
      data = parse_body(res)
      @token = data['CALLINFO']['token']
      data
    end

    ##
    # Invalidates the token.
    def logout
      res = request(:get, '/auth/logout', token: @token)
      data = parse_body(res)
      @token = nil if data['CALLINFO']['status'] == STATUS_SUCCESS
      data
    end

    ##
    # Checks whether or not the token is valid and refreshes the
    # timeout for that token if valid.
    def check
      res = request(:get, '/auth/check', token: @token)
      parse_body(res)
    end
  end
end
