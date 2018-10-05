require 'storedsafe'

describe Storedsafe::Configurable do
  subject { (Class.new { include Storedsafe::Configurable }).new }

  # Mandatory server and credentials
  it { should have_attr_accessor(:server) }
  it { should have_attr_accessor(:token) }

  # Certificate verification settings
  it { should have_attr_accessor(:ca_bundle) }
  it { should have_attr_accessor(:skip_verify) }

  # Configuration opions
  it { should have_attr_accessor(:use_rc) }
  it { should have_attr_accessor(:rc_path) }
  it { should have_attr_accessor(:use_env) }

  # Optional authentication configuration
  it { should have_attr_accessor(:username) }
  it { should have_attr_accessor(:passphrase) }
  it { should have_attr_accessor(:hotp) }
  it { should have_attr_accessor(:totp) }
  it { should have_attr_accessor(:api_key) }
end
