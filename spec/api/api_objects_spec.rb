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

  describe '.get_object' do
    context 'with options default values (children false)' do
      it 'returns success response without decrypted information or children' do
        object_id = 1

        res = api.get_object(object_id)
        expect(res).to eq(response_from_file('object.json'))
      end
    end

    context 'with children = true' do
      it 'returns success response with children' do
        object_id = 1
        children = true

        res = api.get_object(object_id, children)
        expect(res).to eq(response_from_file('object_children.json'))
      end
    end
  end

  describe '.decrypt_object' do
    it 'returns success response with decrypted data' do
      object_id = 1

      res = api.decrypt_object(object_id)
      expect(res).to eq(response_from_file('object_decrypt.json'))
    end
  end

  describe '.create_object' do
    it 'returns success response' do
      args = {
        templateid: 1,
        groupid: 1,
        parentid: 1,
        objectname: "name",
        host: "host",
        username: "username",
        info: "info",
        password: "password",
        cryptedinfo: "cryptedinfo"
      }

      res = api.create_object(**args)
      expect(res).to eq(response_from_file('object_create.json'))
    end
  end

  describe '.edit_object' do
    it 'returns success response' do
      object_id = 1
      args = {
        templateid: 1,
        groupid: 1,
        parentid: 1,
        objectname: "name",
        host: "host",
        username: "username",
        info: "info",
        password: "password",
        cryptedinfo: "cryptedinfo"
      }

      res = api.edit_object(object_id, **args)
      expect(res).to eq(response_from_file('object_edit.json'))
    end
  end

  describe '.delete_object' do
    it 'returns success response' do
      object_id = 1

      res = api.delete_object(object_id)
      expect(res).to eq(response_from_file('object_delete.json'))
    end
  end

  describe '.find' do
    it 'returns success response' do
      needle = 'needle'

      res = api.find(needle)
      expect(res).to eq(response_from_file('find.json'))
    end
  end
end
