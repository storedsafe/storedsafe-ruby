# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'

require_relative 'configurable'
require_relative 'defaults'

require_relative 'api/auth'
require_relative 'api/objects'
require_relative 'api/vaults'
require_relative 'api/templates'

module Storedsafe
  ##
  # Contains all interaction and configuration relating to the remote API.
  class API
    include Configurable

    ##
    # Supported Login Types
    module LoginType
      YUBIKEY    = 'yubikey'  # HOTP with Yubico YubiKey device
      TOTP       = 'totp'     # Time-Based OTP using Authenticator
      SMARTCARD  = 'smc_rest' # Smartcard
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
      url = "https://#{@server}/api/#{@api_version}#{path}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      assign_verify_mode(http)
      request = create_request(method, uri, params)

      http.request(request) if request
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
      when :delete
        create_delete_request(uri, params)
      when :put
        create_put_request(uri, params)
      end
    end

    def create_get_request(uri, params)
      uri.query   = URI.encode_www_form(params)
      request     = Net::HTTP::Get.new(uri)
      request
    end

    def create_delete_request(uri, params)
      headers         = { 'Content-Type': 'application/json' }
      request         = Net::HTTP::Delete.new(uri, headers)
      request.body    = params.to_json
      request
    end

    def create_post_request(uri, params)
      headers         = { 'Content-Type': 'application/json' }
      request         = Net::HTTP::Post.new(uri, headers)
      request.body    = params.to_json
      request
    end

    def create_put_request(uri, params)
      headers         = { 'Content-Type': 'application/json' }
      request         = Net::HTTP::Put.new(uri, headers)
      request.body    = params.to_json
      request
    end

    def parse_body(response)
      body = response.body
      @parser.parse_response(body)
    end
  end
end
