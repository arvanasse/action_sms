require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe ActionSms::Base do
  context 'formatting the address for sms messaging' do
    before :each do
      @instance = ActionSms::Base.new
      @instance.phone_number = '212-555-1234'
    end

    it 'should be valid if the carrier is in the list of known carriers' do
      ActionSms::Base.carriers.keys.each do |carrier_id|
        @instance.carrier = carrier_id
        @instance.should be_valid_sms_address
      end
    end

    it 'should concatenate the phone number and carrier host information as the sms_address' do
      ActionSms::Base.carriers.each do |carrier_id, carrier_attributes|
        @instance.carrier = carrier_id
        @instance.sms_address.should == "#{@instance.formatted_phone_number}#{carrier_attributes['value']}"
      end
    end

    it 'should not be valid if the carrier is not in the list of known carriers' do
      @instance.carrier = 'fail!'
      @instance.should_not be_valid_sms_address
    end

    it 'should return a nil sms_address if the carrier is invalid' do
      @instance.carrier = 'fail!'
      @instance.sms_address.should be_nil
    end
  end
end

