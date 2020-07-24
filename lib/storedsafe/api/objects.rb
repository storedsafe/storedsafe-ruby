# frozen_string_literal: true

module StoredSafe
  ##
  # Handles API requests to the /object path.
  class API
    ##
    # Lists all information regarding an object and optionally lists children
    # of the object.
    # @param [Integer] object_id
    # @param [Boolean] children=false List object children
    def get_object(object_id, children = false)
      request_get("/object/#{object_id}", children: children)
    end

    ##
    # Lists all information regarding an object, including decrypted
    # information.
    # @param [Integer] object_id
    def decrypt_object(object_id)
      request_get("/object/#{object_id}", decrypt: true)
    end

    ##
    # Creates a new object in an existing vault.
    # @param [Hash] args (See API documentation)
    def create_object(args)
      request_post('/object', args)
    end

    ##
    # Edits an existing object.
    # @param [Integer] object_id Object to edit.
    # @param [Hash] args (See API documentation)
    def edit_object(object_id, args)
      request_put("/object/#{object_id}", args)
    end

    ##
    # Deletes an existing object.
    # @param [Integer] object_id
    def delete_object(object_id)
      request_delete("/object/#{object_id}")
    end

    ##
    # Search in unencrypted data to find Objects.
    # @param [String] needle String to match Objects with.
    def find(needle)
      request_get('/find', needle: needle)
    end
  end
end
