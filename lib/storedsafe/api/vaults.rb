# frozen_string_literal: true

module Storedsafe
  ##
  # Handles API requests to the /vault path.
  class API
    ##
    # Lists all Vaults associated with the logged in user.
    def list_vaults
      res = request(:get, '/vault', token: @token)
      parse_body(res)
    end

    ##
    # Lists all objects within the specified Vault.
    def list_objects(vault_id)
      res = request(:get, "/vault/#{vault_id}", token: @token)
      parse_body(res)
    end

    ##
    # Creates an empty Vault, setting current user as "Data Custodian".
    # Requires the authenticated user to have the "Create Vault" capability.
    def create_vault(groupname, policy, description)
      res = request(
        :post, '/vault',
        token: @token,
        groupname: groupname, policy: policy, description: description
      )
      parse_body(res)
    end

    ##
    # Changes information about an existing Vault using the optional
    # parameters passed in the last argument Hash.
    # @param [Hash] args
    # @option args [String] groupname New name of Vault
    # @option args [Integer] policy New password policy
    # @option args [String] description New Vault description.
    def edit_vault(vault_id, args)
      res = request(:put, "/vault/#{vault_id}", { token: @token }.merge(args))
      parse_body(res)
    end

    ##
    # Deletes an existing Vault.
    # Requires the vault to be empty and the authenticated user to have the
    # "Create Vault" capability as well as being "Data Custodian" for the
    # specified Vault.
    def delete_vault(vault_id)
      res = request(:delete, "/vault/#{vault_id}", token: @token)
      parse_body(res)
    end
  end
end
