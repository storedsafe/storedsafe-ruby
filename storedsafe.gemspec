lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'storedsafe'

Gem::Specification.new do |spec|
  spec.name          = 'storedsafe'
  spec.version       = StoredSafe::VERSION

  spec.authors       = ['Oscar Mattsson']
  spec.email         = ['oscar@storedsafe.com']

  spec.summary       = "The Storedsafe gem is a ruby interface for the"\
                       " Storedsafe REST-like API."
  spec.homepage      = 'https://github.com/storedsafe/storedsafe-ruby'
  spec.license       = 'Apache-2.0'

  spec.files         = spec.files = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  spec.require_paths = ['lib']

  spec.metadata = {
    'storedsafe_uri' => 'https://storedsafe.com/'
  }

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', "~> 0.74.0"
  spec.add_development_dependency 'sinatra', "~> 3.0"
  spec.add_development_dependency 'webmock', "~> 3.4"
end
