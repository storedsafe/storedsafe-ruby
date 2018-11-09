require 'storedsafe'

class Config
  include Storedsafe::Configurable
end

RC_FILE_NAME = File.join(Dir.tmpdir, '.storedsafe-client.rc')

describe Storedsafe::Defaults do
  describe '.allocate' do
    before(:each) do
      @config = Config.new
      @config.rc_path = RC_FILE_NAME

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

      rc_file = File.new(RC_FILE_NAME, 'w')
      rc_file.puts "token:#{@rc_token}"
      rc_file.puts "username:#{@rc_username}"
      rc_file.puts "apikey:#{@rc_api_key}"
      rc_file.puts "mysite:#{@rc_server}"
      rc_file.close
    end

    after(:each) do
      File.delete(RC_FILE_NAME)
    end

    context 'use_rc=false, use_env=false and no configuration' do
      it 'does not alter any values' do
        @config.use_rc = false
        @config.use_env = false

        Storedsafe::Defaults.allocate(@config)

        # ENV
        expect(@config.token).to eq(nil)
        expect(@config.server).to eq(nil)
        expect(@config.ca_bundle).to eq(nil)
        expect(@config.skip_verify).to eq(nil)

        # RC (server and token overlap with ENV)
        expect(@config.username).to eq(nil)
        expect(@config.api_key).to eq(nil)
      end
    end
    context 'use_rc=true, use_env=false and no configuration' do
      it 'applies rc values' do
        @config.use_rc = true
        @config.use_env = false

        Storedsafe::Defaults.allocate(@config)

        expect(@config.token).to eq(@rc_token)
        expect(@config.username).to eq(@rc_username)
        expect(@config.api_key).to eq(@rc_api_key)
        expect(@config.server).to eq(@rc_server)
      end
    end
    context 'use_rc=false, use_env=true and no configuration' do
      it 'applies env values' do
        @config.use_rc = false
        @config.use_env = true

        Storedsafe::Defaults.allocate(@config)

        expect(@config.token).to eq(@env_token)
        expect(@config.server).to eq(@env_server)
        expect(@config.ca_bundle).to eq(@env_ca_bundle)
        expect(@config.skip_verify).to eq(@env_skip_verify)
      end
    end
    context 'use_rc=true, use_env=true and no configuration' do
      it 'applies env values and non-overlapping rc values' do
        @config.use_rc = true
        @config.use_env = true

        Storedsafe::Defaults.allocate(@config)

        expect(@config.token).to eq(@env_token)
        expect(@config.server).to eq(@env_server)
        expect(@config.ca_bundle).to eq(@env_ca_bundle)
        expect(@config.skip_verify).to eq(@env_skip_verify)
        expect(@config.username).to eq(@rc_username)
        expect(@config.api_key).to eq(@rc_api_key)
      end
    end
    context 'use_rc=true, use_env=true with configuration' do
      it 'does not alter any values' do
        @config.use_rc = true
        @config.use_env = true

        token = "token"
        server = "server"
        ca_bundle = "ca_bundle"
        skip_verify = "skip_verify"
        username = "username"
        api_key = "api_key"

        @config.token = token
        @config.server = server
        @config.ca_bundle = ca_bundle
        @config.skip_verify = skip_verify
        @config.username = username
        @config.api_key = api_key

        Storedsafe::Defaults.allocate(@config)

        expect(@config.token).to eq(token)
        expect(@config.server).to eq(server)
        expect(@config.ca_bundle).to eq(ca_bundle)
        expect(@config.skip_verify).to eq(skip_verify)
        expect(@config.username).to eq(username)
        expect(@config.api_key).to eq(api_key)
      end
    end
  end
end
