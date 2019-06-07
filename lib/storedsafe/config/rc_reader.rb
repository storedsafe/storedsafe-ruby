# frozen_string_literal: true

module Storedsafe
  module Config
    ##
    # Reads configuration items from rc file.
    class RcReader
      attr_reader :config

      ##
      # Read configuration from Storedsafe RC file.
      # @param [String] path Path to RC file.
      def initialize(path)
        @path = path
        @config = {}
      end

      ##
      # Read values from file into the @config hash.
      def read
        if File.exists?(@path)
          File.open(@path, 'r').each do |line|
            key, val = line.split(':', 2)
            key = key.strip
            val = val.strip
            parse_line(key, val)
          end
        end
        @config
      end

      private

      def parse_line(key, val)
        case key
        when 'token'
          @config[:token] = val
        when 'username'
          @config[:username] = val
        when 'apikey'
          @config[:api_key] = val
        when 'mysite'
          @config[:server] = val
        end
      end
    end
  end
end
