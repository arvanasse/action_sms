require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rubygems'
gem 'mail', '>= 2.1.3'
require 'mail'

describe ActionSms::Base do
  before :each do
    @valid_attributes = {
      :phone_number => '212-555-1234', 
      :carrier => 'alltel',
      :message => "Short message"
    }
  end

  it 'should be able to instantiate from a hash of attributes' do
    instance = ActionSms::Base.new @valid_attributes
    @valid_attributes.each do |accessor_id, value|
      instance.send(accessor_id).should == value
    end
  end

  it 'should be a valid instance if instantiated with valid attributes' do
    ActionSms::Base.new(@valid_attributes).should be_valid
  end

  it 'should not be a valid instance if the message is invalid' do
    @valid_attributes.delete :message
    instance = ActionSms::Base.new(@valid_attributes)

    instance.should_not be_valid_message
    instance.should_not be_valid
  end

  it 'should not be a valid instance if the carrier is unknown' do
    @valid_attributes[:carrier] = 'fail!'
    ActionSms::Base.new(@valid_attributes).should_not be_valid
  end

  it 'should not be a valid instance if the phone number is invalid' do
    @valid_attributes[:phone_number] = '555-1234'
    instance = ActionSms::Base.new(@valid_attributes)

    instance.should_not be_valid_phone_number
    instance.should_not be_valid
  end

  context 'when transmitting a simple message' do
    before :each do
      @instance = ActionSms::Base.new @valid_attributes
      @instance.postmaster.should_receive(:deliver).once.with('Short message', :to=>'2125551234@message.alltel.com', :from=>'noreply@domain.com')
    end

    it 'should send a single message' do
      2.times{ @instance.send_sms }
    end
  end

  context 'when transmitting a long message' do
    before :each do
      @instance = ActionSms::Base.new @valid_attributes.merge(:max_length=>10, :split_message=>true)
      
      ['The quick', 'brown fox', 'jumped!'].each do |phrase|
        @instance.postmaster.should_receive(:deliver).once.with(phrase, :to=>'2125551234@message.alltel.com', :from=>'noreply@domain.com')
      end
    end

    it 'should send multiple messages for the long message' do
      @instance.message = "The quick brown fox jumped!"
      @instance.send_sms
    end
  end
end
