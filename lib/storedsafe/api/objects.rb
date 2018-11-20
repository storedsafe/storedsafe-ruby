# frozen_string_literal: true

module Storedsafe
  module API
    ##
    # Configures API requests to the /object path  on the
    # Storedsafe server.
    module Objects
      class << self
        ##
        # Lists all information regarding an object and optionally
        # decrypts encrypted fields.
        # @param [Method] callback Method that sends the API request.
        # @param [String] object_id ID of the object whose information
        #   we wish to list.
        # @param [Hash] args
        # @option args [String] :token
        # @option args [Boolean] :decrypt Optional
        def get(callback, object_id, args); end

        ##
        # Creates a new object in an existing vault.
        # @param [Method] callback Method that sends the API request.
        # @param [Hash] args
        # @option args [String] :token
        # @option args [String] :template_id
        # @option args [String] :group_id
        # @option args [String] :parent_id
        # @option args [String] :object_name
        # @option args [String] :host Optional, template specific
        # @option args [String] :username Optional, template specific
        # @option args [String] :info Optional, template specific
        # @option args [String] :password Optional, template specific
        # @option args [String] :cryptedinfo Optional, template specific
        def create(callback, args); end

        ##
        # Edits an existing object.
        # @param [Method] callback Method that sends the API request.
        # @param [String] object_id ID of the object we wish to edit.
        # @param [Hash] args
        # @option args [String] :token
        # @option args [String] :template_id
        # @option args [String] :group_id
        # @option args [String] :parent_id
        # @option args [String] :object_name
        # @option args [String] :host Optional, template specific
        # @option args [String] :username Optional, template specific
        # @option args [String] :info Optional, template specific
        # @option args [String] :password Optional, template specific
        # @option args [String] :cryptedinfo Optional, template specific
        def edit(callback, object_id, args); end

        ##
        # Deletes an existing object.
        # @param [Method] callback Method that sends the API request.
        # @param [String] object_id ID of the object we wish to delete.
        # @param [Hash] args
        # @option args [String] :token
        def delete(callback, object_id, args); end

        ##
        # Search in unencrypted data to find an object.
        # @param [Method] callback Method that sends the API request.
        # @param [Hash] args
        # @option args [String] :token
        # @option args [String] :needle Case insensitive
        def find(callback, args); end
      end
    end
  end
end
