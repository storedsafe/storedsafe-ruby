# frozen_string_literal: true

module Storedsafe
  module Defaults
    ##
    # Handles interaction with Storedsafe RC file.
    class Rc
      attr_reader :token, :username, :api_key, :server

      ##
      # Read configuration from Storedsafe RC file.
      # @param [String] path Path to RC file.
      def initialize(path)
        File.open(path, 'r').each do |line|
          key, value = line.split(':', 2)
          key = key.strip
          value = value.strip
          parse_line(key, value)
        end
      end

      ##
      # Write configuration to Storedsafe RC file.
      # @param [String] path Path to RC file.
      # @param [String] token
      # @param [String] username
      # @param [String] api_key
      # @param [String] server
      def write(path, token, username, api_key, server)
        File.open(path, 'w') do |file|
          file.write("token:#{token}")
          file.write("username:#{username}")
          file.write("apikey:#{api_key}")
          file.write("mysite:#{server}")
        end
      end

      private

      def parse_line(key, value)
        case key
        when 'token'
          @token = value
        when 'username'
          @username = value
        when 'apikey'
          @api_key = value
        when 'mysite'
          @server = value
        end
      end
    end
  end
end
