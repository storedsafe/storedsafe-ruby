require 'storedsafe'

describe Storedsafe::Config::RcReader do
  it 'reads settings from rc file' do
    token = 'A1B2C3'
    username = 'johndoe'
    apikey = '1a2B3c4D'
    mysite = 'storedsafe.example.com'

    rc_file_name = File.join(Dir.tmpdir, '.storedsafe-client.rc')
    File.open(rc_file_name, 'w') do |file|
      file.puts "token:#{token}"
      file.puts "username:#{username}"
      file.puts "apikey:#{apikey}"
      file.puts "mysite:#{mysite}"
    end

    config = Storedsafe::Config::RcReader.parse_file(rc_file_name)

    expect(config[:token]).to eq(token)
    expect(config[:username]).to eq(username)
    expect(config[:api_key]).to eq(apikey)
    expect(config[:server]).to eq(mysite)

    File.delete(rc_file_name)
  end
end
