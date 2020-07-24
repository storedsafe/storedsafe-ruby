# frozen_string_literal: true

module StoredSafe
  ##
  # Handles API requests to the /auth path.
  class API
    ##
    # Request list of all users or any users matching search string.
    def list_users(search_string = nil)
      return request_get('/user') if search_string.nil?

      request_get('/user', searchstring: search_string)
    end

    ##
    # Request the creation of a new user.
    def create_user(**args)
      request_post('/user', **args)
    end

    ##
    # Request the creation of a new user."""
    def edit_user(user_id, **args)
      request_put("/user/#{user_id}", **args)
    end

    ##
    # Request the creation of a new user."""
    def delete_user(user_id)
      request_delete("/user/#{user_id}")
    end
  end
end
