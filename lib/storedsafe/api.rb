require_relative 'configurable'
require_relative 'defaults'

module Storedsafe
  ##
  # Manages requests to the Storedsafe RESTlike API.
  ##
  class API
    include Configurable
    def initialize
      yield self
      Defaults.allocate(self)
    end
  end
end
