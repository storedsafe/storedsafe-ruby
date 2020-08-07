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

  describe '.status_values' do
    it 'returns success response with status values' do
      object_id = 1

      res = api.status_values()
      expect(res).to eq(response_from_file('misc_status_values.json'))
    end
  end

  describe '.password_policies' do
    it 'returns success response password policies' do
      res = api.password_policies()
      expect(res).to eq(response_from_file('misc_policies.json'))
    end
  end

  describe '.version' do
    it 'returns success response with StoredSafe version' do
      res = api.version()
      expect(res).to eq(response_from_file('misc_version.json'))
    end
  end

  describe '.generate_password' do
    context 'no arguments' do
      it 'returns success response with password' do
        res = api.generate_password()
        expect(res).to eq(response_from_file('misc_pwgen.json'))
      end
    end

    context 'with arguments' do
      it 'returns success response with password' do
        args = {
          type: 'diceword',
          words: '5',
          language: 'en_US',
        }

        res = api.generate_password(**args)
        expect(res).to eq(response_from_file('misc_pwgen.json'))
      end
    end
  end
end
