# frozen_string_literal: true

module Storedsafe
  module API
    ##
    # Configures and sends API requests to the /auth path on the
    # Storedsafe server.
    module Auth
      class << self
        ##
        # Authenticates a user with a Yubico OTP.
        # @param [Method] callback Method that sends the API request.
        # @param [Hash] args
        # @option args [String] :username
        # @option args [String] :passphrase
        # @option args [String] :api_key
        # @option args [String] :otp
        # @see authenticate_otp Authentication with other OTP types.
        def authenticate_yubikey(callback, args)
          params = {
            username: args[:username],
            keys: "#{args[:passphrase]}#{args[:api_key]}#{args[:otp]}"
          }
          callback.call(:post, '/auth', params)
        end

        ##
        # Authenticates a user with a OTP other than Yubikey.
        # @param [Method] callback Method that sends the API request.
        # @param [Hash] args
        # @option args [String] username
        # @option args [String] passphrase
        # @option args [String] otp
        # @option args [String] api_key
        # @option args [String] login_type
        # @see authenticate_yubikey Authentication with Yubico OTP.
        def authenticate_otp(callback, args)
          params = {
            username: args[:username],
            passphrase: args[:passphrase],
            otp: args[:otp],
            logintype: args[:login_type]
          }
          callback.call(:post, '/auth', params)
        end

        ##
        # Invalidates the token.
        # @param [Method] callback Method that sends the API request.
        # @param [Hash] args
        # @option args [String] token
        def logout(callback, args)
          params = {
            token: args[:token]
          }
          callback.call(:get, '/auth/logout', params)
        end

        ##
        # Checks whether or not the token is valid and refreshes the
        # timeout for that token if valid.
        # @param [Method] callback Method that sends the API request.
        # @param [Hash] args
        # @option args [String] token
        def check(callback, args)
          params = {
            token: args[:token]
          }
          callback.call(:get, '/auth/check', params)
        end
      end
    end
  end
end
