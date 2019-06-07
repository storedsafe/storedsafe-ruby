require 'storedsafe'

describe Storedsafe::Config::RcReader do
  it 'reads settings from rc file' do
    token = 'A1B2C3'
    username = 'johndoe'
    apikey = '1a2B3c4D'
    mysite = 'storedsafe.example.com'

    RC_FILE_NAME = File.join(Dir.tmpdir, '.storedsafe-client.rc')
    File.open(RC_FILE_NAME, 'w') do |file|
      file.puts "token:#{token}"
      file.puts "username:#{username}"
      file.puts "apikey:#{apikey}"
      file.puts "mysite:#{mysite}"
    end

    rc = Storedsafe::Config::RcReader.new(RC_FILE_NAME)
    config = rc.read

    expect(config[:token]).to eq(token)
    expect(config[:username]).to eq(username)
    expect(config[:api_key]).to eq(apikey)
    expect(config[:server]).to eq(mysite)

    File.delete(RC_FILE_NAME)
  end
end
