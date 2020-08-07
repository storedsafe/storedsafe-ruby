# frozen_string_literal: true

module StoredSafe
  ##
  # Handles API requests to the /auth path.
  class API
    ##
    # Request a list of all available capabilities and permission bits.
    def status_values
      request_get('/utils/statusvalues')
    end

    ##
    # Request a list of all available password policies.
    def password_policies
      request_get('/utils/policies')
    end

    ##
    # Request the version of the StoredSafe server.
    def version
      request_get('/utils/version')
    end

    ##
    # Request a password generated with the passed settings.
    def generate_password(**args)
      request_get('/utils/pwgen', **args)
    end
  end
end
