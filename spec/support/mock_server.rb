require 'sinatra/base'

class MockServer < Sinatra::Base

    before do
        unless request.secure?
            # TODO: Handle requests without https
        end
    end

    # Auth
    post '/api/1.0/auth' do
        # HOTP auth
        if params['username'] && params['keys']      
            # TODO: Add HOTP response
        # TOTP Auth
        elsif
            params['username'] &&
            params['passphrase'] &&
            params['otp'] &&
            params['apikey']
            # TODO: Add TOTP response
        else
            # TODO: Add error response
        end
    end

    # Logout
    get '/api/1.0/auth/logout' do
        if token_valid? params
            # TODO: Add logout response
        else
            # TODO: Add error response
        end
    end

    # Check
    get '/api/1.0/auth/check' do
        if token_valid? params
            # TODO: Add logout response
        else
            # TODO: Add error response
        end
    end

    # Vaults
    get '/api/1.0/vault' do
        if token_valid? params
            # TODO: Add logout response
        else
            # TODO: Add error response       
        end
    end

    # List objects in vault
    get '/api/1.0/vault/:vault_id' do
        if token_valid? params
            # TODO: Add list vault objects response
        else
            # TODO: Add error response
        end
    end

    # Create vault
    post '/api/1.0/vault' do
        if 
            token_valid? params &&
            params['groupname'] &&
            params['policy'] &&
            params['description']
            # TODO: Add vault add response
        else
            # TODO: Add error response
        end
    end

    # Edit vault
    put '/api/1.0/vault/:vault_id' do
        if
            token_valid? params &&
            params['groupname'] &&
            params['policy'] && # TODO: Handle optional parameter
            params['description']
            # TODO: Add vault edit response
        else
            # TODO: Add error response
        end
    end

    # Delete vault
    delete '/api/1.0/vault/:vault_id' do
        if token_valid? params
            # TODO: Add vault delete response
        else
            # TODO: Add error response
        end
    end

    # List objects
    get '/api/1.0/object/:object_id' do
        if token_valid? params
            if params['decrypt']
                # TODO: Add list objects response after decryption
            else
                # TODO: Add list objects response without decryption
            end
        else
            # TODO: Add error response
    end

    # Create object
    post '/api/1.0/object' do
        if 
            token_valid? params &&
            params['templateid'] &&
            params['groupid'] &&
            params['parentid'] &&
            params['objectname'] &&
            params['host'] && # TODO: Handle template dependency
            params['username'] && # TODO: Handle template dependency
            params['info'] && # TODO: Handle template dependency
            params['password'] && # TODO: Handle template dependency
            params['cryptedinfo'] # TODO: Handle template dependency
            # TODO: Add create object response
        else
            # TODO: Add error response
        end
    end

    # Edit object
    put '/api/1.0/object/:object_id' do
        if 
            token_valid? params &&
            params['templateid'] &&
            params['groupid'] &&
            params['parentid'] &&
            params['objectname'] &&
            params['host'] && # TODO: Handle template dependency
            params['username'] && # TODO: Handle template dependency
            params['info'] && # TODO: Handle template dependency
            params['password'] && # TODO: Handle template dependency
            params['cryptedinfo'] # TODO: Handle template dependency
            # TODO: Add edit object response
        else
            # TODO: Add error response
        end
    end

    delete '/api/1.0/object/:object_id' do
        if token_valid? params
            # TODO: Add delete object response
        else
            # TODO: Add error response
        end
    end

    # Search objects
    get '/api/1.0/find' do
        if token_valid? params && params['needle']
            # TODO: Add search object response
        else
            # TODO: Add error response
        end
    end

    # List templates
    get '/api/1.0/template' do
        if token_valid? params
            # TODO: Add list templates response
        else
            # TODO: Add error response
        end
    end

    # Retrieve template
    get '/api/1.0/template/:template_id' do
        if token_valid? params
            # TODO: Add retrieve template response
        else
            # TODO: Add error response
        end
    end

    helpers do
        # Verify that token exists and that it is valid.
        # TODO: Reconisder method name
        def token_valid? params
            token = params['token']
            if token
                # TODO: Verify token
            else false
            end
        end
    end

    # Run server for manual testing of mock server
    # Start server with 'bundle exec ruby spec/support/mock_server.rb'
    run! if app_file == $0
end