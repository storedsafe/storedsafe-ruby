require 'storedsafe'

##
# The API class is split into several files, spec files for other parts of the
# API class should be put in separate spec files like api_<filename>_spec.rb.
describe StoredSafe::API do
  describe '.new' do
    context 'with manually assigned config' do
      it 'creates an API instance with given config' do
        config_sources = []
        host = 'host'
        token = 'token'
        ca_bundle = 'ca_bundle'
        skip_verify = 'skip_verify'
        apikey = 'apikey'

        api = StoredSafe::API.new do |config|
          config.config_sources = config_sources
          config.host = host
          config.token = token
          config.ca_bundle = ca_bundle
          config.skip_verify = skip_verify
          config.apikey = apikey
        end

        expect(api.config_sources).to eq(config_sources)
        expect(api.host).to eq(host)
        expect(api.token).to eq(token)
        expect(api.ca_bundle).to eq(ca_bundle)
        expect(api.skip_verify).to eq(skip_verify)
        expect(api.apikey).to eq(apikey)
      end
    end
  end
end
