Gem::Specification.new do |s|
  s.files = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_paths = ['lib']
  s.name          = 'storedsafe'
  s.version       = '0.0.1'
  s.summary       = 'Storedsafe is a ruby wrapper for the Storedsafe REST-like'\
                    ' API.'

  s.author        = 'Oscar Mattsson'
  s.email         = 'oscar_mattsson@live.se'
  s.homepage      = 'https://github.com/storedsafe/storedsafe-ruby'
  s.license       = 'Apache-2.0'

  s.metadata = {
    'storedsafe_uri' => 'https://storedsafe.com/'
  }
end
