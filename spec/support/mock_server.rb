# frozen_string_literal: true

require 'sinatra/base'

class MockServer < Sinatra::Base # rubocop:disable Metrics/ClassLength

  set :show_exceptions, false

  USERNAME = 'foo@example.com'
  PASSPHRASE = 'ThisIsAPrettyLousyPassPhrase'
  OTP = '123456'
  APIKEY = 'My-API-Key'
  KEYS = "#{PASSPHRASE}#{APIKEY}#{OTP}"
  TOKEN = "StoredSafe-Token"

  FIXTURES = 'spec/support/fixtures'

  before do
    content_type 'application/json'
    unless request.secure?
      halt 404
    end
  end

  def response_from_file(file)
    file = File.read("#{FIXTURES}/#{file}")
    JSON.parse(file).to_json
  end

  def error_response
    response_from_file('error.json')
  end

  def parse_body
    request.body.rewind
    JSON.parse(request.body.read)
  end

  # Auth
  post '/api/1.0/auth' do
    data = parse_body

    # HOTP auth
    if data.key?('username') && data.key?('keys')
      auth_hotp(data)

    # TOTP Auth
    elsif data['username'] &&
          data['passphrase'] &&
          data['otp'] &&
          data['apikey'] &&
          data['logintype']
      auth_totp(data)
    # Missing parameters
    else
      status 403
      error_response
    end
  end

  def auth_hotp(data)
    if data['username'] == USERNAME &&
       data['keys'] == KEYS
      status 200
      response_from_file('auth_hotp.json')
    else
      status 403
      error_response
    end
  end

  def auth_totp(data)
    puts("DEBUG: #{data}")
    if data['username'] == USERNAME &&
       data['passphrase'] == PASSPHRASE &&
       data['otp'] == OTP &&
       data['apikey'] == APIKEY
      status 200
      response_from_file('auth_totp.json')
    else
      status 403
      error_response
    end
  end

  # Logout
  get '/api/1.0/auth/logout' do
    if token_valid?(request)
      status 200
      response_from_file('auth_logout.json')
    else
      status 403
      error_response
    end
  end

  # Check
  get '/api/1.0/auth/check' do
    if token_valid?(request)
      status 200
      response_from_file('auth_check.json')
    else
      status 403
      error_response
    end
  end

  # Vaults
  get '/api/1.0/vault' do
    if token_valid?(request)
      status 200
      response_from_file('vault.json')
    else
      status 403
      error_response
    end
  end

  # List objects in vault
  get '/api/1.0/vault/:vault_id' do
    if token_valid?(request)
      status 200
      response_from_file('vault_objects.json')
    else
      status 403
      error_response
    end
  end

  # List members in vault
  get '/api/1.0/vault/:vault_id/members' do
    if token_valid?(request)
      status 200
      response_from_file('vault_members.json')
    else
      status 403
      error_response
    end
  end

  # Create vault
  post '/api/1.0/vault' do
    data = parse_body
    if token_valid?(request) &&
       data['groupname'] &&
       data['policy'] &&
       data['description']
      status 200
      response_from_file('vault_create.json')
    else
      status 403
      error_response
    end
  end

  # Edit vault
  put '/api/1.0/vault/:vault_id' do
    data = parse_body
    if token_valid?(request) &&
       data['groupname'] &&
       data['policy'] &&
       data['description']
      status 200
      response_from_file('vault_edit.json')
    else
      status 403
      error_response
    end
  end

  # Delete vault
  delete '/api/1.0/vault/:vault_id' do
    data = parse_body
    if token_valid?(request)
      status 200
      response_from_file('vault_delete.json')
    else
      status 403
      error_response
    end
  end

  # List objects
  get '/api/1.0/object/:object_id' do
    if token_valid?(request)
      status 200
      if params['decrypt'] == 'true' and params['children'] == 'true'
        error_response
      elsif params['decrypt'] == 'true'
        response_from_file('object_decrypt.json')
      elsif params['children'] == 'true'
        response_from_file('object_children.json')
      else
        response_from_file('object.json')
      end
    else
      status 403
      error_response
    end
  end

  # Create object
  post '/api/1.0/object' do
    data = parse_body
    if token_valid?(request) &&
       data['templateid'] &&
       data['groupid'] &&
       data['parentid'] &&
       data['objectname'] &&
       data['host'] &&
       data['username'] &&
       data['info'] &&
       data['password'] &&
       data['cryptedinfo']
      status 200
      response_from_file('object_create.json')
    else
      status 403
      error_response
    end
  end

  # Edit object
  put '/api/1.0/object/:object_id' do
    data = parse_body
    if token_valid?(request) &&
       data['templateid'] &&
       data['groupid'] &&
       data['parentid'] &&
       data['objectname'] &&
       data['host'] &&
       data['username'] &&
       data['info'] &&
       data['password'] &&
       data['cryptedinfo']
      status 200
      response_from_file('object_edit.json')
    else
      status 403
      error_response
    end
  end

  delete '/api/1.0/object/:object_id' do
    data = parse_body
    if token_valid?(request)
      status 200
      response_from_file('object_delete.json')
    else
      status 403
      error_response
    end
  end

  # Search objects
  get '/api/1.0/find' do
    if token_valid?(request) && params['needle']
      status 200
      response_from_file('find.json')
    else
      status 403
      error_response
    end
  end

  # List templates
  get '/api/1.0/template' do
    if token_valid?(request)
      status 200
      response_from_file('template.json')
    else
      status 403
      error_response
    end
  end

  # Get template
  get '/api/1.0/template/:template_id' do
    if token_valid?(request)
      status 200
      response_from_file('template_get.json')
    else
      status 403
      error_response
    end
  end

  helpers do
    # Verify that token exists and that it is valid.
    def token_valid?(request)
      token = request.env['HTTP_X_HTTP_TOKEN']
      return token == TOKEN if token
      false
    end
  end

  # Run server for manual testing of mock server
  # Start server with `bundle exec ruby spec/support/mock_server.rb`
  run! if app_file == $PROGRAM_NAME
end
