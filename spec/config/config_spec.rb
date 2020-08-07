require 'storedsafe'

class FakeConfigurable
  include StoredSafe::Config::Configurable
end

describe StoredSafe::Config do
  rc_file_name = File.join(Dir.tmpdir, '.storedsafe-client.rc')

  describe '.apply' do
    before(:each) do
      @fc = FakeConfigurable.new

      @env_token = "env_token"
      @env_host = "env_host"
      @env_ca_bundle = "env_ca_bundle"
      @env_skip_verify = "env_skip_verify"

      @rc_token = "rc_token"
      @rc_apikey = "rc_apikey"
      @rc_host = "rc_host"

      allow(ENV).to receive(:[]).with('STOREDSAFE_TOKEN')
        .and_return(@env_token)
      allow(ENV).to receive(:[]).with('STOREDSAFE_SERVER')
        .and_return(@env_host)
      allow(ENV).to receive(:[]).with('STOREDSAFE_CABUNDLE')
        .and_return(@env_ca_bundle)
      allow(ENV).to receive(:[]).with('STOREDSAFE_SKIP_VERIFY')
        .and_return(@env_skip_verify)

      File.open(rc_file_name, 'w') do |file|
        file.puts "token:#{@rc_token}"
        file.puts "apikey:#{@rc_apikey}"
        file.puts "mysite:#{@rc_host}"
      end

      @rc = StoredSafe::Config::RcReader.parse_file(rc_file_name)
      @env = StoredSafe::Config::EnvReader.parse_env
    end

    after(:each) do
      File.delete(rc_file_name)
    end

    context 'with no configuration sources' do
      it 'does not alter any values' do
        @fc.config_sources = []

        StoredSafe::Config.apply(@fc)

        # ENV
        expect(@fc.token).to eq(nil)
        expect(@fc.host).to eq(nil)
        expect(@fc.ca_bundle).to eq(nil)
        expect(@fc.skip_verify).to eq(nil)

        # RC (host and token overlap with ENV)
        expect(@fc.apikey).to eq(nil)
      end
    end

    context 'with hash config' do
      it 'passes configuration from hash' do
        token = 'token'
        host = 'host'
        apikey = 'apikey'

        @fc.config_sources = [{
          token: token,
          host: host,
          apikey: apikey
        }]

        StoredSafe::Config.apply(@fc)

        expect(@fc.token).to eq(token)
        expect(@fc.host).to eq(host)
        expect(@fc.apikey).to eq(apikey)
      end
    end

    context 'with only rc config' do
      it 'applies rc values' do
        @fc.config_sources = [@rc]

        StoredSafe::Config.apply(@fc)

        expect(@fc.token).to eq(@rc_token)
        expect(@fc.apikey).to eq(@rc_apikey)
        expect(@fc.host).to eq(@rc_host)
      end
    end

    context 'with only env config' do
      it 'applies env values' do
        @fc.config_sources = [@env]

        StoredSafe::Config.apply(@fc)

        expect(@fc.token).to eq(@env_token)
        expect(@fc.host).to eq(@env_host)
        expect(@fc.ca_bundle).to eq(@env_ca_bundle)
        expect(@fc.skip_verify).to eq(@env_skip_verify)
      end
    end

    context 'with env before rc config' do
      it 'applies env values and non-overlapping rc values' do
        @fc.config_sources = [@env, @rc]

        StoredSafe::Config.apply(@fc)

        expect(@fc.token).to eq(@env_token)
        expect(@fc.host).to eq(@env_host)
        expect(@fc.ca_bundle).to eq(@env_ca_bundle)
        expect(@fc.skip_verify).to eq(@env_skip_verify)
        expect(@fc.apikey).to eq(@rc_apikey)
      end
    end

    context 'with rc before env config' do
      it 'applies rc values and non-overlapping env values' do
        @fc.config_sources = [@rc, @env]

        StoredSafe::Config.apply(@fc)

        expect(@fc.apikey).to eq(@rc_apikey)
        expect(@fc.token).to eq(@rc_token)
        expect(@fc.host).to eq(@rc_host)
        expect(@fc.ca_bundle).to eq(@env_ca_bundle)
        expect(@fc.skip_verify).to eq(@env_skip_verify)
      end
    end

    context 'with rc and env after passed config' do
      it 'does not alter any values' do
        @fc.config_sources = [@rc, @env]

        token = 'token'
        host = 'host'
        ca_bundle = 'ca_bundle'
        skip_verify = 'skip_verify'
        apikey = 'apikey'

        @fc.token = token
        @fc.host = host
        @fc.ca_bundle = ca_bundle
        @fc.skip_verify = skip_verify
        @fc.apikey = apikey

        StoredSafe::Config.apply(@fc)

        expect(@fc.token).to eq(token)
        expect(@fc.host).to eq(host)
        expect(@fc.ca_bundle).to eq(ca_bundle)
        expect(@fc.skip_verify).to eq(skip_verify)
        expect(@fc.apikey).to eq(apikey)
      end
    end
  end
end
