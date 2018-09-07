##
# Ruby wrapper for the Storedsafe RESTlike API.
##
module Storedsafe
  class << self
    require_relative 'storedsafe/api'
    require_relative 'storedsafe/configurable'
    require_relative 'storedsafe/defaults'

    def configure
      API.new do |api|
        yield api
      end
    end
  end
end
