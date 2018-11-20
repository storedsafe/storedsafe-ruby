require 'storedsafe'

describe Storedsafe::API do
  describe '.new' do
    context 'with manually assigned config' do
      it 'creates an API instance with given config' do
        server = 'server'
        token = 'token'
        ca_bundle = 'ca_bundle'
        skip_verify = 'skip_verify'
        username = 'username'
        api_key = 'api_key'

        api = Storedsafe::API::APIHandler.new do |config|
          config.server = server
          config.token = token
          config.ca_bundle = ca_bundle
          config.skip_verify = skip_verify
          config.username = username
          config.api_key = api_key
        end

        expect(api.server).to eq(server)
        expect(api.token).to eq(token)
        expect(api.ca_bundle).to eq(ca_bundle)
        expect(api.skip_verify).to eq(skip_verify)
        expect(api.username).to eq(username)
        expect(api.api_key).to eq(api_key)
      end
    end
  end

  describe '.authenticate_yubikey', :type => :api do
    it 'successfully authenticates a user' do
      api = Storedsafe::API::APIHandler.new do |config|
        config.server = STOREDSAFE_SERVER
        config.username = MockServer::USERNAME
        config.api_key = MockServer::APIKEY
      end
      api.authenticate_yubikey(MockServer::PASSPHRASE, MockServer::OTP)
      expect(api.token).to eq(MockServer::TOKEN)
    end
  end
end
