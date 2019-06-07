require 'storedsafe'

describe Storedsafe::API, :type => :api  do
  let!(:api) do
    Storedsafe::API.new do |config|
      config.server = STOREDSAFE_SERVER
      config.parser = Storedsafe::Parser::RawParser
      config.username = MockServer::USERNAME
      config.api_key = MockServer::APIKEY
      config.config_sources = []
    end
  end

  describe '.authenticate_yubikey' do
    it 'successfully receives a token' do
      api.token = nil

      res = api.authenticate_yubikey(MockServer::PASSPHRASE, MockServer::OTP)
      expect(api.token).to eq(MockServer::TOKEN)
      expect(res).to eq(response_from_file('auth_hotp.json'))
    end
  end

  describe '.authenticate' do
    it 'successfully receives a token' do
      api.token = nil

      res = api.authenticate(MockServer::PASSPHRASE, MockServer::OTP)
      expect(api.token).to eq(MockServer::TOKEN)
      expect(res).to eq(response_from_file('auth_totp.json'))
    end
  end

  describe '.logout' do
    it 'successfully invalidates the token' do
      api.token = MockServer::TOKEN

      res = api.logout
      expect(api.token).to eq(nil)
      expect(res).to eq(response_from_file('auth_logout.json'))
    end
  end

  describe '.check' do
    context 'with an invalid token' do
      it 'returns an error response' do
        api.token = MockServer::TOKEN + 'invalid'
        res = api.check
        expect(res).to eq(response_from_file('error.json'))
      end
    end
    context 'with a valid token' do
      it 'returns a valid response' do
        api.token = MockServer::TOKEN
        res = api.check
        expect(res).to eq(response_from_file('auth_check.json'))
      end
    end
  end
end
