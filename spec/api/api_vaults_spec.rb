require 'storedsafe'

describe StoredSafe::API, :type => :api do
  let(:api) do
    StoredSafe::API.new do |config|
      config.host = STOREDSAFE_SERVER
      config.token = MockServer::TOKEN
      config.parser = StoredSafe::Parser::RawParser
      config.config_sources = []
    end
  end

  describe '.list_vaults' do
    it 'returns success response' do
      res = api.list_vaults
      expect(res).to eq(response_from_file('vault.json'))
    end
  end

  describe '.vault_objects' do
    it 'returns success response' do
      vault_id = 1
      res = api.vault_objects(vault_id)
      expect(res).to eq(response_from_file('vault_objects.json'))
    end
  end

  describe '.vault_members' do
    it 'returns success response' do
      vault_id = 1
      res = api.vault_members(vault_id)
      expect(res).to eq(response_from_file('vault_members.json'))
    end
  end

  describe '.add_vault_member' do
    it 'returns success response' do
      vault_id = 1
      user_id = 2
      status = 4
      res = api.add_vault_member(vault_id, user_id, status)
      expect(res).to eq(response_from_file('vault_members_add.json'))
    end
  end

  describe '.edit_vault_member' do
    it 'returns success response' do
      vault_id = 1
      user_id = 2
      status = 2
      res = api.edit_vault_member(vault_id, user_id, status)
      expect(res).to eq(response_from_file('vault_members_edit.json'))
    end
  end

  describe '.remove_vault_member' do
    it 'returns success response' do
      vault_id = 1
      user_id = 2
      res = api.remove_vault_member(vault_id, user_id)
      expect(res).to eq(response_from_file('vault_members_remove.json'))
    end
  end

  describe '.create_vault' do
    it 'returns success response' do
      args = {
        groupname: 'name',
        policy: 1,
        description: 'description'
      }

      res = api.create_vault(**args)
      expect(res).to eq(response_from_file('vault_create.json'))
    end
  end

  describe '.edit_vault' do
    it 'returns success response' do
      vault_id = 1
      args = {
        groupname: 'name',
        policy: 1,
        description: 'description'
      }

      res = api.edit_vault(vault_id, **args)
      expect(res).to eq(response_from_file('vault_edit.json'))
    end
  end

  describe '.delete_vault' do
    it 'returns success response' do
      vault_id = 1

      res = api.delete_vault(vault_id)
      expect(res).to eq(response_from_file('vault_delete.json'))
    end
  end
end
