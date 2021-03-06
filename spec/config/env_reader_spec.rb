require 'storedsafe'

describe StoredSafe::Config::EnvReader do
  context 'with no parameters given' do
    it 'reads settings from env with default keys' do
      token = 'A1B2C3'
      server = 'storedsafe.example.com'
      ca_bundle = 'trustme'
      skip_verify = true

      allow(ENV).to receive(:[]).with('STOREDSAFE_TOKEN')
        .and_return(token)
      allow(ENV).to receive(:[]).with('STOREDSAFE_SERVER')
        .and_return(server)
      allow(ENV).to receive(:[]).with('STOREDSAFE_CABUNDLE')
        .and_return(ca_bundle)
      allow(ENV).to receive(:[]).with('STOREDSAFE_SKIP_VERIFY')
        .and_return(skip_verify)

      config = StoredSafe::Config::EnvReader.parse_env

      expect(config[:token]).to eq(token)
      expect(config[:host]).to eq(server)
      expect(config[:ca_bundle]).to eq(ca_bundle)
      expect(config[:skip_verify]).to eq(skip_verify)
    end
  end

  context 'with parameters' do
    it 'reads settings from env with given keys' do
      token = 'q1w2e3r4'
      server = 'fake.example.com'
      ca_bundle = 'secret'
      skip_verify = false

      allow(ENV).to receive(:[]).with('FAKE_TOKEN')
        .and_return(token)
      allow(ENV).to receive(:[]).with('FAKE_SERVER')
        .and_return(server)
      allow(ENV).to receive(:[]).with('FAKE_CABUNDLE')
        .and_return(ca_bundle)
      allow(ENV).to receive(:[]).with('FAKE_SKIP_VERIFY')
        .and_return(skip_verify)

      config = StoredSafe::Config::EnvReader.parse_env({
        token: 'FAKE_TOKEN',
        host: 'FAKE_SERVER',
        ca_bundle: 'FAKE_CABUNDLE',
        skip_verify: 'FAKE_SKIP_VERIFY'
      })

      expect(config[:token]).to eq(token)
      expect(config[:host]).to eq(server)
      expect(config[:ca_bundle]).to eq(ca_bundle)
      expect(config[:skip_verify]).to eq(skip_verify)
    end
  end
end
