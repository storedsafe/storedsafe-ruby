require 'storedsafe'

describe Storedsafe::Defaults do
  # Mandatory server and credentials
  it { should respond_to(:server) }
  it { should respond_to(:token) }

  # Certificate verification settings
  it { should respond_to(:ca_bundle) }
  it { should respond_to(:skip_verify) }

  # Configuration opions
  it { should respond_to(:use_rc) }
  it { should respond_to(:rc_path) }
  it { should respond_to(:use_env) }

  # Optional authentication configuration
  it { should respond_to(:username) }
  it { should respond_to(:passphrase) }
  it { should respond_to(:hotp) }
  it { should respond_to(:totp) }
  it { should respond_to(:api_key) }
end
