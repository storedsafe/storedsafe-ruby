require 'storedsafe'

describe StoredSafe::Config::RcReader do
  it 'reads settings from rc file' do
    token = 'A1B2C3'
    apikey = '1a2B3c4D'
    mysite = 'storedsafe.example.com'

    rc_file_name = File.join(Dir.tmpdir, '.storedsafe-client.rc')
    File.open(rc_file_name, 'w') do |file|
      file.puts "token:#{token}"
      file.puts "apikey:#{apikey}"
      file.puts "mysite:#{mysite}"
    end

    config = StoredSafe::Config::RcReader.parse_file(rc_file_name)

    expect(config[:token]).to eq(token)
    expect(config[:apikey]).to eq(apikey)
    expect(config[:host]).to eq(mysite)

    File.delete(rc_file_name)
  end
end
