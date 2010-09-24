require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe ActionSms::Base do
  context 'formatting phone numbers' do
    before :each do
      @instance = ActionSms::Base.new
    end

    it 'should strip out whitespaces' do
      @instance.phone_number = '985 123 4567'
      @instance.formatted_phone_number.should == '9851234567'
    end

    it 'should strip out dashes' do
      @instance.phone_number = '985-123-4567'
      @instance.formatted_phone_number.should == '9851234567'
    end

    it 'should strip out periods' do
      @instance.phone_number = '985.123.4567'
      @instance.formatted_phone_number.should == '9851234567'
    end

    it 'should strip out parentheses' do
      @instance.phone_number = '(985) 123-4567'
      @instance.formatted_phone_number.should == '9851234567'
    end

    it 'should strip out alphas' do
      @instance.phone_number = 'KL5-123-4567'
      @instance.formatted_phone_number.should == '51234567'
    end

    it 'should NOT strip out pluses' do
      @instance.phone_number = '011+985 123-4567'
      @instance.formatted_phone_number.should == '011+9851234567'
    end

    it 'should strip out a leading 1 in the phone number' do
      @instance.phone_number = '1-985-123-4567'
      @instance.formatted_phone_number.should == '9851234567'
    end

    it 'should not be valid if the length is less than 10' do
      bad_phone = ''
      9.downto(1) do |digit|
        bad_phone = "#{bad_phone}#{digit}"
        @instance.phone_number = bad_phone
        @instance.should_not be_valid_phone_number
      end
    end

    it 'should be valid with ten or more digits' do
      @instance.phone_number = '2125551234'
      @instance.should be_valid_phone_number
    end

    it 'should require eleven or more digits to be valid if the first digit is a 1' do
      @instance.phone_number = '1225551234'
      @instance.should_not be_valid_phone_number
      
      @instance.phone_number = '12125551234'
      @instance.should be_valid_phone_number
    end
  end
end

