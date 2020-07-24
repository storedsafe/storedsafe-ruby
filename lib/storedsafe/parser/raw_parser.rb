# frozen_string_literal: true

require 'json'

module StoredSafe
  module Parser
    ##
    # Transparent parser for the StoredSafe API.
    module RawParser
      class << self
        ##
        # Transparently parses the StoredSafe API response into a ruby Hash.
        # @return [Hash]
        def parse_response(res)
          JSON.parse(res)
        end
      end
    end
  end
end
