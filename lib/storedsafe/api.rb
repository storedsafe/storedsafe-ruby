# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'

require 'storedsafe/config'

require_relative 'api/auth'
require_relative 'api/objects'
require_relative 'api/vaults'
require_relative 'api/templates'
require_relative 'api/users'
require_relative 'api/misc'

module StoredSafe
  class ConnectionError < StandardError
  end

  ##
  # Contains all interaction and configuration relating to the remote API.
  class API
    include StoredSafe::Config::Configurable

    ##
    # Creates a new API handler with the passed configuration,
    # then allocates remaining uninitialized values with values from
    # alternate sources.
    # @see StoredSafe::Config
    def initialize
      yield self
      Config.apply(self)
    end

    private

    def create_headers()
      { 'X-Http-Token': @token }
    end

    def request_auth(**params)
      request(
        :post, '/auth',
        apikey: @apikey, **params
      )
    end

    def request_get(path, **params)
      request(:get, path, params, create_headers)
    end

    def request_post(path, **params)
      request(:post, path, params, create_headers)
    end

    def request_put(path, **params)
      request(:put, path, params, create_headers)
    end

    def request_delete(path, **params)
      request(:delete, path, params, create_headers)
    end

    ##
    # Sends a request to the StoredSafe API.
    # @param [String] method HTTP method used for request.
    # @param [String] path Endpoint path relative to the API
    #   root on the server.
    # @param [Hash] params Data to be sent with the request.
    def request(method, path, params, headers = {})
      url = "https://#{@host}/api/#{@version}#{path}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      assign_verify_mode(http)
      request = create_request(method, uri, params, headers)

      res = http.request(request) if request
      parse_body(res)
    rescue SocketError => e
      raise ConnectionError, e.message
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

    def create_request(method, uri, params, headers)
      case method
      when :get
        create_get_request(uri, params, headers)
      when :post
        create_post_request(uri, params, headers)
      when :delete
        create_delete_request(uri, params, headers)
      when :put
        create_put_request(uri, params, headers)
      end
    end

    def create_get_request(uri, params, headers)
      uri.query   = URI.encode_www_form(params)
      request     = Net::HTTP::Get.new(uri, headers)
      request
    end

    def create_delete_request(uri, params, headers)
      headers       = { 'Content-Type': 'application/json', **headers }
      request       = Net::HTTP::Delete.new(uri, headers)
      request.body  = params.to_json
      request
    end

    def create_post_request(uri, params, headers)
      headers       = { 'Content-Type': 'application/json', **headers }
      request       = Net::HTTP::Post.new(uri, headers)
      request.body  = params.to_json
      request
    end

    def create_put_request(uri, params, headers)
      headers       = { 'Content-Type': 'application/json', **headers }
      request       = Net::HTTP::Put.new(uri, headers)
      request.body  = params.to_json
      request
    end

    def parse_body(response)
      body = response.body
      @parser.parse_response(body)
    end
  end
end
