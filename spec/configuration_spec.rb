require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), 'configuration_standard')

describe ActionSms::Base do
  context 'configuration' do
    before :all do
      File.open( File.join(File.dirname(__FILE__), '..', 'lib', 'action_sms', 'sms_fu.yml')) do |conf|
        @config = YAML.load(conf)
      end
    end

    it_should_behave_like 'standard configuration'
  end

  context 'within Rails' do
    before :all do
      Rails = mock('rails', :root => File.join(File.dirname(__FILE__), 'rails') )
      load File.join(File.dirname(__FILE__), 'spec_helper.rb')

      File.open( File.join(Rails.root, 'config', 'sms_fu.yml') ) do |conf|
        @config = YAML.load(conf)
      end
    end

    it_should_behave_like 'standard configuration'
  end
end
