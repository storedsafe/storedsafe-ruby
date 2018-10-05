require 'storedsafe'

# The Storedsafe module entry point is simply a wrapper for the
# API class, all actual configuration test should be put in the
# tests for the API class.
describe Storedsafe do
  describe '.configure' do
    it 'returns an API instance' do
      api = Storedsafe.configure do |config|
      end
      expect(api).to be_instance_of(Storedsafe::API)
    end
  end
end
