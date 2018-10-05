require 'storedsafe'

describe Storedsafe::API do
  describe '.new' do
    context 'with manually assigned config' do
      it 'creates an API instance with given config' do
        server = 'server'
        token = 'token'
        ca_bundle = 'ca_bundle'
        skip_verify = 'skip_verify'
        use_rc = 'use_rc'
        rc_path = 'rc_path'
        use_env = 'use_env'
        username = 'username'
        passphrase = 'passphrase'
        hotp = 'hotp'
        totp = 'totp'
        api_key = 'api_key'

        api = Storedsafe::API.new do |config|
          config.server = server
          config.token = token
          config.ca_bundle = ca_bundle
          config.skip_verify = skip_verify
          config.use_rc = use_rc
          config.rc_path = rc_path
          config.use_env = use_env
          config.username = username
          config.passphrase = passphrase
          config.hotp = hotp
          config.totp = totp
          config.api_key = api_key
        end

        expect(api.server).to eq(server)
        expect(api.token).to eq(token)
        expect(api.ca_bundle).to eq(ca_bundle)
        expect(api.skip_verify).to eq(skip_verify)
        expect(api.use_rc).to eq(use_rc)
        expect(api.rc_path).to eq(rc_path)
        expect(api.use_env).to eq(use_env)
        expect(api.username).to eq(username)
        expect(api.passphrase).to eq(passphrase)
        expect(api.hotp).to eq(hotp)
        expect(api.totp).to eq(totp)
        expect(api.api_key).to eq(api_key)
      end
    end
  end
end
