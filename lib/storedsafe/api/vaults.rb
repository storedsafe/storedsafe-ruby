# frozen_string_literal: true

module Storedsafe
  ##
  # Handles API requests to the /vault path.
  class API
    ##
    # Lists all Vaults associated with the logged in user.
    def list_vaults
      request(:get, '/vault', token: @token)
    end

    ##
    # Lists all objects within the specified Vault.
    # @param [Integer] vault_id
    # @see list_vaults
    def list_objects(vault_id)
      request(:get, "/vault/#{vault_id}", token: @token)
    end

    ##
    # Creates an empty Vault, setting current user as "Data Custodian".
    # Requires the authenticated user to have the "Create Vault" capability.
    # @param [String] groupname Name of Vault.
    # @param [Integer] policy Password policy.
    # @param [String] description
    def create_vault(groupname, policy, description)
      request(
        :post, '/vault',
        token: @token,
        groupname: groupname, policy: policy, description: description
      )
    end

    ##
    # Changes information about an existing Vault using the optional
    # parameters passed in the last argument Hash.
    # @param [Integer] vault_id
    # @param [Hash] args
    # @option args [String] groupname New name of Vault
    # @option args [Integer] policy New password policy
    # @option args [String] description New Vault description.
    def edit_vault(vault_id, args)
      request(:put, "/vault/#{vault_id}", { token: @token }.merge(args))
    end

    ##
    # Deletes an existing Vault.
    # Requires the vault to be empty and the authenticated user to have the
    # "Create Vault" capability as well as being "Data Custodian" for the
    # specified Vault.
    # @param [Integer] vault_id
    def delete_vault(vault_id)
      request(:delete, "/vault/#{vault_id}", token: @token)
    end
  end
end
