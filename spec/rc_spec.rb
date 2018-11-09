require 'storedsafe/defaults'

describe Storedsafe::Defaults::Rc do
  it 'reads settings from rc file' do
    token = 'A1B2C3'
    username = 'johndoe'
    apikey = '1a2B3c4D'
    mysite = 'storedsafe.example.com'

    rc_file_name = File.join(Dir.tmpdir, '.storedsafe-client.rc')
    rc_file = File.new(rc_file_name, 'w')
    rc_file.puts "token:#{token}"
    rc_file.puts "username:#{username}"
    rc_file.puts "apikey:#{apikey}"
    rc_file.puts "mysite:#{mysite}"

    rc_file.close

    rc = Storedsafe::Defaults::Rc.new(rc_file_name)
    expect(rc.token).to eq(token)
    expect(rc.username).to eq(username)
    expect(rc.api_key).to eq(apikey)
    expect(rc.server).to eq(mysite)

    File.delete(rc_file_name)
  end
end
