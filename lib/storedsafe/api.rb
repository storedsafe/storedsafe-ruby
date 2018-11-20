# frozen_string_literal: true

require_relative 'configurable'
require_relative 'defaults'
require_relative 'api/auth'
require_relative 'api/objects'
require_relative 'api/vaults'
require_relative 'api/templates'

module Storedsafe
  ##
  # Contains all interaction and configuration relating to the remote API.
  module API
    ##
    # Handles or delegates the handling of all requests to the remote API.
    class APIHandler
      include Configurable

      FIELD_ERRORS = 'ERRORS'
      FIELD_DATA = 'DATA'
      FIELD_PARAMS = 'PARAMS'
      FIELD_CALLINFO = 'CALLINFO'

      STATUS_SUCCESS = 'SUCCESS'
      STATUS_FAIL = 'FAIL'

      ##
      # Authenticate using a Yubico OTP.
      def authenticate_yubikey(passphrase, otp)
        res = Auth.authenticate_yubikey(
          method(:request),
          username: @username,
          passphrase: passphrase,
          api_key: @api_key,
          otp: otp
        )
        data = parse_body(res)
        @token = data[FIELD_CALLINFO]['token']
        @token
      end

      ##
      # Authenticate using OTP method other than Yubico.
      def authenticate_otp(passphrase, otp, logintype='totp')
        res = Auth.authenticate_otp(
          method(:request),
          username: @username,
          passphrase: passphrase,
          api_key: @api_key,
          otp: otp,
          logintype: logintype
        )
        data = parse_body(res)
        @token = data[FIELD_CALLINFO]['token']
        @token
      end

      ##
      # Log out current user.
      def logout
        res = Auth.logout(
          method(:request),
          token: @token
        )
        @token = nil if res.code == '200'
      end

      ##
      # Check if the current token is valid and refresh the timeout if it is.
      # @return [Boolean] true if the token is valid, otherwise false.
      def check_token?
        return false if token.nil?
        res = Auth.check(
          method(:request),
          token: @token
        )
        data = parse_body(res)
        return data[FIELD_CALLINFO]['status'] == STATUS_SUCCESS
      end

      ##
      # Creates a new APIHandler instance with the passed configuration,
      # then allocates remaining uninitialized values with values from
      # alternate sources.
      # @see Storedsafe::Defaults
      def initialize
        yield self
        Defaults.allocate(self)
      end

      private

      ##
      # Sends a request to the StoredSafe API.
      # @param [String] method HTTP method used for request.
      # @param [String] path Endpoint path relative to the API
      #   root on the server.
      # @param [Hash] params Data to be sent with the request.
      def request(method, path, params)
        return unless @server && @api_version

        url = "https://#{@server}/api/#{@api_version}#{path}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        assign_verify_mode(http)
        request = create_request(method, uri, params)

        return http.request(request) if request
      end

      def assign_verify_mode(http)
        if @skip_verify
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        else
          http.verify_mode    = OpenSSL::SSL::VERIFY_PEER
          http.ca_path        = @ca_path if @ca_path
          http.verify_depth   = 5
        end
      end

      def create_request(method, uri, params)
        case method
        when :get
          create_get_request(uri, params)
        when :post
          create_post_request(uri, params)
        end
      end

      def create_get_request(uri, params)
        uri.query   = URI.encode_www_form(params)
        request     = Net::HTTP::Get.new(uri)
        request
      end

      def create_post_request(uri, params)
        headers         = { 'Content-Type': 'application/json' }
        request         = Net::HTTP::Post.new(uri, headers)
        request.body    = params.to_json
        request
      end

      def parse_body(response)
        JSON.parse(response.body)
      end
    end
  end
end
