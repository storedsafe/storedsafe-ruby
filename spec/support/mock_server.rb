require 'sinatra/base'

class MockServer < Sinatra::Base # rubocop:disable Metrics/ClassLength
  USERNAME = 'foo@example.com'.freeze
  PASSPHRASE = 'ThisIsAPrettyLousyPassPhrase'.freeze
  OTP = '123456'.freeze
  APIKEY = 'My-API-Key'.freeze
  KEYS = "#{PASSPHRASE}#{APIKEY}OhMyCouldThisReallyBeAnOTP".freeze

  FIXTURES = 'spec/support/fixtures'.freeze

  before do
    content_type 'application/json'
    unless request.secure?
      # halt 404
    end
  end

  def response_from_file(file)
    file = File.read("#{FIXTURES}/#{file}")
    JSON.parse(file).to_json
  end

  def error_response
    response_from_file('error.json')
  end

  # Auth
  post '/api/1.0/auth' do
    # HOTP auth
    if params.key?('username') && params.key?('keys')
      auth_hotp(params)

    # TOTP Auth
    elsif params['username'] &&
          params['passphrase'] &&
          params['otp'] &&
          params['apikey'] &&
          params['logintype']
      auth_totp(params)
    # Missing parameters
    else
      status 403
      error_response
    end
  end

  def auth_hotp(params)
    if params['username'] == USERNAME &&
       params['keys'] == KEYS
      status 200
      response_from_file('auth_hotp.json')
    else
      status 403
      error_response
    end
  end

  def auth_totp(params)
    if params['username'] == USERNAME &&
       params['passphrase'] == PASSPHRASE &&
       params['otp'] == OTP &&
       params['apikey'] == APIKEY
      status 200
      response_from_file('auth_totp.json')
    else
      status 403
      error_response
    end
  end

  # Logout
  get '/api/1.0/auth/logout' do
    if token_valid?(params)
      status 200
      response_from_file('auth_logout.json')
    else
      status 403
      error_response
    end
  end

  # Check
  get '/api/1.0/auth/check' do
    if token_valid?(params)
      status 200
      response_from_file('check.json')
    else
      status 403
      error_response
    end
  end

  # Vaults
  get '/api/1.0/vault' do
    if token_valid?(params)
      status 200
      response_from_file('vault.json')
    else
      status 403
      error_response
    end
  end

  # List objects in vault
  get '/api/1.0/vault/:vault_id' do
    if token_valid?(params)
      status 200
      response_from_file('vault_objects.json')
    else
      status 403
      error_response
    end
  end

  # Create vault
  post '/api/1.0/vault' do
    if token_valid?(params) &&
       params['groupname'] &&
       params['policy'] &&
       params['description']
      status 200
      response_from_file('vault_create.json')
    else
      status 403
      error_response
    end
  end

  # Edit vault
  put '/api/1.0/vault/:vault_id' do
    if token_valid?(params) &&
       params['groupname'] &&
       # params['policy'] && # TODO: Handle optional parameter
       params['description']
      status 200
      response_from_file('vault_edit.json')
    else
      status 403
      error_response
    end
  end

  # Delete vault
  delete '/api/1.0/vault/:vault_id' do
    if token_valid?(params)
      status 200
      response_from_file('vault_delete.json')
    else
      status 403
      error_response
    end
  end

  # List objects
  get '/api/1.0/object/:object_id' do
    if token_valid?(params)
      status 200
      if params['decrypt']
        response_from_file('object_decrypt.json')
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
    if token_valid?(params) &&
       params['templateid'] &&
       params['groupid'] &&
       params['parentid'] &&
       params['objectname'] # &&
      # params['host'] && # TODO: Handle template dependency
      # params['username'] && # TODO: Handle template dependency
      # params['info'] && # TODO: Handle template dependency
      # params['password'] && # TODO: Handle template dependency
      # params['cryptedinfo'] # TODO: Handle template dependency
      status 200
      response_from_file('object_create.json')
    else
      status 403
      error_response
    end
  end

  # Edit object
  put '/api/1.0/object/:object_id' do
    if token_valid?(params) &&
       params['templateid'] &&
       params['groupid'] &&
       params['parentid'] &&
       params['objectname'] # &&
      # params['host'] && # TODO: Handle template dependency
      # params['username'] && # TODO: Handle template dependency
      # params['info'] && # TODO: Handle template dependency
      # params['password'] && # TODO: Handle template dependency
      # params['cryptedinfo'] # TODO: Handle template dependency
      status 200
      response_from_file('object_edit.json')
    else
      status 403
      error_response
    end
  end

  delete '/api/1.0/object/:object_id' do
    if token_valid?(params)
      status 200
      response_from_file('object_delete.json')
    else
      status 403
      error_response
    end
  end

  # Search objects
  get '/api/1.0/find' do
    if token_valid?(params) && params['needle']
      status 200
      response_from_file('find.json')
    else
      status 403
      error_response
    end
  end

  # List templates
  get '/api/1.0/template' do
    if token_valid?(params)
      status 200
      response_from_file('template.json')
    else
      status 403
      error_response
    end
  end

  # Retrieve template
  get '/api/1.0/template/:template_id' do
    if token_valid?(params)
      status 200
      response_from_file('template_retreive.json')
    else
      status 403
      error_response
    end
  end

  helpers do
    # Verify that token exists and that it is valid.
    # TODO: Reconsider method name
    def token_valid?(params)
      token = params['token']
      if token
      # TODO: Verify token
      else false
      end
    end
  end

  # Run server for manual testing of mock server
  # Start server with `bundle exec ruby spec/support/mock_server.rb`
  run! if app_file == $PROGRAM_NAME
end
