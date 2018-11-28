require 'storedsafe'

describe Storedsafe::API, :type => :api do
  let(:api) do
    Storedsafe::API.new do |config|
      config.server = STOREDSAFE_SERVER
      config.token = MockServer::TOKEN
      config.parser = Storedsafe::Parser::RawParser
    end
  end

  describe '.list_templates' do
    it 'returns success response' do
      res = api.list_templates
      expect(res).to eq(response_from_file('template.json'))
    end
  end

  describe '.retrieve_template' do
    it 'returns success response' do
      template_id = 1

      res = api.retrieve_template(template_id)
      expect(res).to eq(response_from_file('template_retrieve.json'))
    end
  end
end
