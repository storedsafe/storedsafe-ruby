module Storedsafe
  module Defaults
    class Rc
      attr_reader :token, :username, :api_key, :server

      def initialize(path)
        File.open(path, 'r').each do |line|
          key, value = line.split(':', 2)

          key = key.strip
          value = value.strip

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
end
