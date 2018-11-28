require 'storedsafe'

describe Storedsafe::API, :type => :api do
  let(:api) do
    Storedsafe::API.new do |config|
      config.server = STOREDSAFE_SERVER
      config.token = MockServer::TOKEN
      config.parser = Storedsafe::Parser::RawParser
    end
  end

  describe '.list_information' do
    context 'with default decrypt=false' do
      it 'returns success response without decrypted information' do
        object_id = 1

        res = api.list_information(object_id)
        expect(res).to eq(response_from_file('object.json'))
      end
    end

    context 'with decrypt=true' do
      it 'returns success response with decrypted data' do
        object_id = 1
        decrypt = true

        res = api.list_information(object_id, decrypt)
        expect(res).to eq(response_from_file('object_decrypt.json'))
      end
    end
  end

  describe '.create_object' do
    it 'returns success response' do
      template_id = 1
      group_id = 1
      parent_id = 1
      object_name = "name"
      template_args = {
        host: "host",
        username: "username",
        info: "info",
        password: "password",
        cryptedinfo: "cryptedinfo"
      }

      res = api.create_object(
        template_id,
        group_id,
        parent_id,
        object_name,
        template_args
      )
      expect(res).to eq(response_from_file('object_create.json'))
    end
  end

  describe '.edit_object' do
    it 'returns success response' do
      object_id = 1
      template_id = 1
      group_id = 1
      parent_id = 1
      object_name = "name"
      template_args = {
        host: "host",
        username: "username",
        info: "info",
        password: "password",
        cryptedinfo: "cryptedinfo"
      }

      res = api.edit_object(
        object_id,
        template_id,
        group_id,
        parent_id,
        object_name,
        template_args
      )
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

  describe '.find_object' do
    it 'returns success response' do
      needle = 'needle'

      res = api.find_object(needle)
      expect(res).to eq(response_from_file('find.json'))
    end
  end
end
