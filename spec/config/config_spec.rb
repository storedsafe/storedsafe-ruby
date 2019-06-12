require 'storedsafe'

class FakeConfigurable
  include Storedsafe::Config::Configurable
end

describe Storedsafe::Config do
  rc_file_name = File.join(Dir.tmpdir, '.storedsafe-client.rc')

  describe '.apply' do
    before(:each) do
      @fc = FakeConfigurable.new

      @env_token = "env_token"
      @env_server = "env_server"
      @env_ca_bundle = "env_ca_bundle"
      @env_skip_verify = "env_skip_verify"

      @rc_token = "rc_token"
      @rc_username = "rc_username"
      @rc_api_key = "rc_api_key"
      @rc_server = "rc_server"

      allow(ENV).to receive(:[]).with('STOREDSAFE_TOKEN')
        .and_return(@env_token)
      allow(ENV).to receive(:[]).with('STOREDSAFE_SERVER')
        .and_return(@env_server)
      allow(ENV).to receive(:[]).with('STOREDSAFE_CABUNDLE')
        .and_return(@env_ca_bundle)
      allow(ENV).to receive(:[]).with('STOREDSAFE_SKIP_VERIFY')
        .and_return(@env_skip_verify)

      File.open(rc_file_name, 'w') do |file|
        file.puts "token:#{@rc_token}"
        file.puts "username:#{@rc_username}"
        file.puts "apikey:#{@rc_api_key}"
        file.puts "mysite:#{@rc_server}"
      end

      @rc = Storedsafe::Config::RcReader.parse_file(rc_file_name)
      @env = Storedsafe::Config::EnvReader.parse_env
    end

    after(:each) do
      File.delete(rc_file_name)
    end

    context 'with no configuration sources' do
      it 'does not alter any values' do
        @fc.config_sources = []

        Storedsafe::Config.apply(@fc)

        # ENV
        expect(@fc.token).to eq(nil)
        expect(@fc.server).to eq(nil)
        expect(@fc.ca_bundle).to eq(nil)
        expect(@fc.skip_verify).to eq(nil)

        # RC (server and token overlap with ENV)
        expect(@fc.username).to eq(nil)
        expect(@fc.api_key).to eq(nil)
      end
    end

    context 'with hash config' do
      it 'passes configuration from hash' do
        token = 'token'
        server = 'server'
        api_key = 'api_key'

        @fc.config_sources = [{
          token: token,
          server: server,
          api_key: api_key
        }]

        Storedsafe::Config.apply(@fc)

        expect(@fc.token).to eq(token)
        expect(@fc.server).to eq(server)
        expect(@fc.api_key).to eq(api_key)
      end
    end

    context 'with only rc config' do
      it 'applies rc values' do
        @fc.config_sources = [@rc]

        Storedsafe::Config.apply(@fc)

        expect(@fc.token).to eq(@rc_token)
        expect(@fc.username).to eq(@rc_username)
        expect(@fc.api_key).to eq(@rc_api_key)
        expect(@fc.server).to eq(@rc_server)
      end
    end

    context 'with only env config' do
      it 'applies env values' do
        @fc.config_sources = [@env]

        Storedsafe::Config.apply(@fc)

        expect(@fc.token).to eq(@env_token)
        expect(@fc.server).to eq(@env_server)
        expect(@fc.ca_bundle).to eq(@env_ca_bundle)
        expect(@fc.skip_verify).to eq(@env_skip_verify)
      end
    end

    context 'with env before rc config' do
      it 'applies env values and non-overlapping rc values' do
        @fc.config_sources = [@env, @rc]

        Storedsafe::Config.apply(@fc)

        expect(@fc.token).to eq(@env_token)
        expect(@fc.server).to eq(@env_server)
        expect(@fc.ca_bundle).to eq(@env_ca_bundle)
        expect(@fc.skip_verify).to eq(@env_skip_verify)
        expect(@fc.username).to eq(@rc_username)
        expect(@fc.api_key).to eq(@rc_api_key)
      end
    end

    context 'with rc before env config' do
      it 'applies rc values and non-overlapping env values' do
        @fc.config_sources = [@rc, @env]

        Storedsafe::Config.apply(@fc)

        expect(@fc.username).to eq(@rc_username)
        expect(@fc.api_key).to eq(@rc_api_key)
        expect(@fc.token).to eq(@rc_token)
        expect(@fc.server).to eq(@rc_server)
        expect(@fc.ca_bundle).to eq(@env_ca_bundle)
        expect(@fc.skip_verify).to eq(@env_skip_verify)
      end
    end

    context 'with rc and env after passed config' do
      it 'does not alter any values' do
        @fc.config_sources = [@rc, @env]

        token = 'token'
        server = 'server'
        ca_bundle = 'ca_bundle'
        skip_verify = 'skip_verify'
        username = 'username'
        api_key = 'api_key'

        @fc.token = token
        @fc.server = server
        @fc.ca_bundle = ca_bundle
        @fc.skip_verify = skip_verify
        @fc.username = username
        @fc.api_key = api_key

        Storedsafe::Config.apply(@fc)

        expect(@fc.token).to eq(token)
        expect(@fc.server).to eq(server)
        expect(@fc.ca_bundle).to eq(ca_bundle)
        expect(@fc.skip_verify).to eq(skip_verify)
        expect(@fc.username).to eq(username)
        expect(@fc.api_key).to eq(api_key)
      end
    end
  end
end
