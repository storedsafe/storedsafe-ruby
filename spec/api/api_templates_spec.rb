require 'storedsafe'

describe StoredSafe::API, :type => :api do
  let(:api) do
    StoredSafe::API.new do |config|
      config.host = STOREDSAFE_SERVER
      config.token = MockServer::TOKEN
      config.parser = StoredSafe::Parser::RawParser
      config.config_sources = []
    end
  end

  describe '.list_templates' do
    it 'returns success response' do
      res = api.list_templates
      expect(res).to eq(response_from_file('template.json'))
    end
  end

  describe '.get_template' do
    it 'returns success response' do
      template_id = 1

      res = api.get_template(template_id)
      expect(res).to eq(response_from_file('template_get.json'))
    end
  end
end
