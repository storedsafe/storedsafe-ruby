require_relative 'configurable'
require_relative 'defaults'

module Storedsafe
  ##
  # Manages requests to the Storedsafe RESTlike API.
  ##
  class API
    include Configurable
    def initialize
      Configurable.keys.each do |key|
        value = Defaults.public_send(key)
        instance_variable_set(:"@#{key}", value)
      end

      yield self
    end
  end
end
