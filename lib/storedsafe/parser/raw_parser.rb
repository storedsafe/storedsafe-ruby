# frozen_string_literal: true

require 'json'

module Storedsafe
  module Parser
    ##
    # Transparent parser for the Storedsafe API.
    module RawParser
      class << self
        ##
        # Transparently parses the Storedsafe API response into a ruby Hash.
        # @return [Hash]
        def parse_response(res)
          JSON.parse(res)
        end
      end
    end
  end
end
