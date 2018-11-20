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
    it 'successfully receives a token' do
      api = Storedsafe::API::APIHandler.new do |config|
        config.server = STOREDSAFE_SERVER
        config.username = MockServer::USERNAME
        config.api_key = MockServer::APIKEY
        config.token = nil
      end
      api.authenticate_yubikey(MockServer::PASSPHRASE, MockServer::OTP)
      expect(api.token).to eq(MockServer::TOKEN)
    end
  end

  describe '.authenticate_otp', :type => :api do
    it 'successfully receives a token' do
      api = Storedsafe::API::APIHandler.new do |config|
        config.server = STOREDSAFE_SERVER
        config.username = MockServer::USERNAME
        config.api_key = MockServer::APIKEY
        config.token = nil
      end
      api.authenticate_otp(MockServer::PASSPHRASE, MockServer::OTP)
      expect(api.token).to eq(MockServer::TOKEN)
    end
  end

  describe '.logout', :type => :api do
    it 'successfully invalidates the token' do
      api = Storedsafe::API::APIHandler.new do |config|
        config.server = STOREDSAFE_SERVER
        config.token = MockServer::TOKEN
      end
      api.logout
      expect(api.token).to eq(nil)
    end
  end

  describe '.check?', :type => :api do
    context 'with valid token' do
      it 'returns true' do
        api = Storedsafe::API::APIHandler.new do |config|
          config.server = STOREDSAFE_SERVER
          config.token = MockServer::TOKEN
        end
        expect(api.check_token?).to eq(true)
      end
    end

    context 'with invalid token' do
      it 'returns false' do
        api = Storedsafe::API::APIHandler.new do |config|
          config.server = STOREDSAFE_SERVER
          config.token = MockServer::TOKEN + 'invalid'
        end
        expect(api.check_token?).to eq(false)
      end
    end
  end
end
