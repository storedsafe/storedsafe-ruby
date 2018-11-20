# frozen_string_literal: true

module Storedsafe
  ##
  # Set up fields needed for configuration of Storedsafe connection.
  ##
  module Configurable
    attr_accessor(
      :server,
      :token,
      :ca_bundle,
      :skip_verify,
      :use_rc,
      :rc_path,
      :use_env,
      :username,
      :api_key,
      :api_version
    )
  end
end
