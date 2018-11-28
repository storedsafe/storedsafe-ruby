require 'storedsafe'

describe Storedsafe::API, :type => :api do
  let(:api) do
    Storedsafe::API.new do |config|
      config.server = STOREDSAFE_SERVER
      config.token = MockServer::TOKEN
      config.parser = Storedsafe::Parser::RawParser
    end
  end

  describe '.list_vaults' do
    it 'returns success response' do
      res = api.list_vaults
      expect(res).to eq(response_from_file('vault.json'))
    end
  end

  describe '.list_objects' do
    it 'returns success response' do
      vault_id = 1
      res = api.list_objects(vault_id)
      expect(res).to eq(response_from_file('vault_objects.json'))
    end
  end

  describe '.create_vault' do
    it 'returns success response' do
      groupname = 'name'
      policy = 1
      description = 'description'

      res = api.create_vault(groupname, policy, description)
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

      res = api.edit_vault(vault_id, args)
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
