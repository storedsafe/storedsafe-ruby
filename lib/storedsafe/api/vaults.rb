# frozen_string_literal: true

module StoredSafe
  ##
  # Handles API requests to the /vault path.
  class API
    ##
    # Lists all Vaults associated with the logged in user.
    def list_vaults
      request_get('/vault')
    end

    ##
    # Lists all objects within the specified Vault.
    # @param [Integer] vault_id
    # @see list_vaults
    def vault_objects(vault_id)
      request_get("/vault/#{vault_id}")
    end

    ##
    # Lists all members with access to the specified Vault.
    # @param [Integer] vault_id
    # @see list_vaults
    def vault_members(vault_id)
      request_get("/vault/#{vault_id}/members")
    end

    ##
    # Add a member to the specified Vault.
    # @param [Integer] vault_id
    # @param [Integer] user_id
    # @param [Integer] status
    # @see list_vaults
    def add_vault_member(vault_id, user_id, status)
      request_post("/vault/#{vault_id}/member/#{user_id}", status: status)
    end

    ##
    # Edit a member's privileges in the specified Vault.
    # @param [Integer] vault_id
    # @param [Integer] user_id
    # @param [Integer] status
    # @see list_vaults
    def edit_vault_member(vault_id, user_id, status)
      request_put("/vault/#{vault_id}/member/#{user_id}", status: status)
    end

    ##
    # Remove a member from the specified Vault.
    # @param [Integer] vault_id
    # @param [Integer] user_id
    # @see list_vaults
    def remove_vault_member(vault_id, user_id)
      request_delete("/vault/#{vault_id}/member/#{user_id}")
    end

    ##
    # Creates an empty Vault, setting current user as "Data Custodian".
    # Requires the authenticated user to have the "Create Vault" capability.
    # @param [String] groupname Name of Vault.
    # @param [Integer] policy Password policy.
    # @param [String] description
    # @param [Hash] args (See API documentation)
    def create_vault(**args)
      request_post('/vault', **args)
    end

    ##
    # Changes information about an existing Vault using the optional
    # parameters passed in the last argument Hash.
    # @param [Integer] vault_id
    # @param [Hash] args (See API documentation)
    def edit_vault(vault_id, **args)
      request_put("/vault/#{vault_id}", **args)
    end

    ##
    # Deletes an existing Vault.
    # Requires the vault to be empty and the authenticated user to have the
    # "Create Vault" capability as well as being "Data Custodian" for the
    # specified Vault.
    # @param [Integer] vault_id
    def delete_vault(vault_id)
      request_delete("/vault/#{vault_id}")
    end
  end
end
