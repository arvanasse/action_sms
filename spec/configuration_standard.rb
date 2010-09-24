describe 'standard configuration', :shared => true do
  it "should configure the class-level sender_email from the included sms_fu.yml" do
    ActionSms::Base.sender_email.should == @config['config']['from_address']
  end

  it "should load all the carriers listed in the included sms_fu.yml" do
    validate_all_keys_are_present @config, ActionSms::Base.carriers
  end

  it "should load only the carriers listed in the included sms_fu.yml" do
    validate_all_keys_are_present ActionSms::Base.carriers, @config
  end

  it "should load the mail settings included in the sms_fu.yml" do
    validate_all_keys_are_present @config, ActionSms::Base.mail_settings
  end

  it 'should load only the mail settings listed in the included sms_fu.yml' do
    validate_all_keys_are_present ActionSms::Base.mail_settings, @config
  end

  def validate_all_keys_are_present( source_hash, validated_hash )
    source_hash.keys.each do |key, value|
      validated_hash[key].should == value
    end
  end
end


