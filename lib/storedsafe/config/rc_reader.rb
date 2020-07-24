# frozen_string_literal: true

module StoredSafe
  module Config
    ##
    # Reads configuration items from rc file.
    module RcReader
      class << self
        ##
        # Parses values from RC file into a hash.
        def parse_file(path = File.join(
          Dir.home,
          '.storedsafe-client.rc'
        ))
          config = {}
          if File.exist?(path)
            File.open(path, 'r').each do |line|
              key, val = line.split(':', 2)
              key = key.strip
              val = val.strip
              parse_line(config, key, val)
            end
          end
          config
        end

        private

        def parse_line(config, key, val)
          case key
          when 'token'
            config[:token] = val
          when 'apikey'
            config[:apikey] = val
          when 'mysite'
            config[:host] = val
          end
        end
      end
    end
  end
end
