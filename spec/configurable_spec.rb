require 'storedsafe'

describe Storedsafe::Configurable do
  subject { (Class.new { include Storedsafe::Configurable }).new }

  fields = %i[
    server token ca_bundle skip_verify use_rc rc_path
    use_env api_version username api_key
  ]

  fields.each do |field|
    it { should have_attr_accessor(field) }
  end

  it 'should only have specified attr_accessor methods' do
    # Regex removes setters (ending with =)
    methods = Storedsafe::Configurable.instance_methods.grep(/.*(?<!=)$/)
    expect(methods - fields).to eq([])
    expect(fields - methods).to eq([])
  end
end
