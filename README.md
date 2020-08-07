# StoredSafe API ruby wrapper

Transparent Ruby wrapper for the StoredSafe REST-like API. (See full [docs here](https://developer.storedsafe.com/)).

Full documentation of the API response signatures and more advanced paramters can be found at the [StoredSafe API Documentation](https://developer.storedsafe.com/).

## Install

Install from rubygems `gem install storedsafe`

Add to Gemfile `gem 'storedsafe', '~> 1.0.0'`

Alternatively, if you whish to install the gem manually, you can clone this repo and build the gem yourself.

```bash
git clone https://github.com/storedsafe/storedsafe-ruby
cd storedsafe-ruby
gem build storedsafe.gemspec
gem install storedsafe-1.0.0.gem
```

## Usage

```ruby
require 'storedsafe'
api = StoredSafe.configure do |config|
  config.host = 'my.site.com'
  config.apikey = 'my-api-key'
end

# Auth
api.login_totp(username, passphrase, otp)
api.login_yubikey(username, passphrase, otp)
api.logout()
api.check()

# Vaults
api.list_vaults()
api.vault_objects(vault_id)
api.vault_members(vault_id)
api.add_vault_member(vault_id, user_id, status)
api.edit_vault_member(vault_id, user_id, status)
api.remove_vault_member(vault_id, user_id)
api.create_vault(**args) # See parameters in API documentation
api.edit_vault(vault_id, **args)
api.delete_vault(vault_id)

# Objects
api.get_object(object_id) # String or integer
api.get_object(object_id, include_children) # children False by default
api.decrypt_object(object_id)
api.create_object(**args)
api.edit_object(object_id, **args)
api.delete_object(object_id)

# Users
api.list_users() # List all users
api.list_users(user_id) # List specific user
api.list_users(search_string) # Search for any user matching search_string
api.create_user(**args)
api.edit_user(user_id, **args)
api.delete_user(user_id)

# Utils
api.status_values()
api.password_policies()
api.version()
api.generate_password() # Use vault policy
api.generate_password(**args)
```

## Examples

### Generate password
```ruby
res = api.generate_password(type: 'diceword', words: 6, delimiter: '_')
password = res['CALLINFO']['passphrase']
```

## Configuration
Configuration can be done in a few different ways. Other than the manual configuration, external configuration sources can be applied through the *config\_sources* array. This array contains Ruby Hashes with the fields that should be applied to the `StoredSafe::Config::Configurable` instance. By default fetch configurations through the `StoredSafe::Config::RcReader` and `StoredSafe::Config::EnvReader`.

The order of priority between these different configuration sources are:
1. Manual Configuration
2. Built-in defaults
3. Elements in the config\_sources array in order of appearance

The **RcReader** will extract a configuration hash from a file (default is ~/.storedsafe-client.rc) which is generated by the [StoredSafe Tokenhandler](https://github.com/storedsafe/tokenhandler).

The **EnvReader** will extract a configuration hash from environment variables. By default these variables are `STOREDSAFE_SERVER`, `STOREDSAFE_TOKEN`, `STOREDSAFE_CABUNDLE` and `STOREDSAFE_SKIP_VERIFY`.

To disable all external configuration sources such as the rc-file and environment vairables, set the *config\_sources* option to an empty array.
```
api = StoredSafe.configure do |config|
  config.config_sources = []
  ...
end
```

If you want to add your own configurations, simply add them to the config\_sources array.
```
def fetch_password(options, obj_id)
  api = StoredSafe.configure do |config|
    config.config_sources = [
      options,
      StoredSafe::Config::RcReader.parse_file('/path/to/.storedsafe-client.rc'),
    ]
  end
  res = api.decrypt_object(obj_id)
  res['OBJECT'][0]['crypted']['password']
end
```
