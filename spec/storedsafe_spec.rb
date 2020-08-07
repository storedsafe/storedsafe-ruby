require 'storedsafe'

# The StoredSafe module entry point is simply a wrapper for the
# API class, all actual configuration test should be put in the
# tests for the API class.
describe StoredSafe do
  describe '.configure' do
    it 'returns an APIHandler instance' do
      api = StoredSafe.configure do |config|
        config.config_sources = []
      end
      expect(api).to be_instance_of(StoredSafe::API)
    end
  end
end
