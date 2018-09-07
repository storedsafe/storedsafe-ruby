require_relative 'configurable'
require_relative 'defaults'

module Storedsafe
  ##
  # Manages requests to the Storedsafe RESTlike API.
  ##
  class API
    include Storedsafe::Configurable
    def initialize
      Storedsafe::Configurable.keys.each do |key|
        value = Defaults.public_send(key)
        instance_variable_set(:"@#{key}", value)
      end

      yield self
    end
  end
end
