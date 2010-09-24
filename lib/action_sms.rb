Dir.glob File.join(File.dirname(__FILE__), 'action_sms', '*.rb') do |filename|
  require filename
end

require 'rubygems'
gem 'mail', '>= 2.1.3'
require 'mail'

module ActionSms
  class Base
    attr_accessor :sender_email

    extend ActionSms::Configuration::Base
    if defined?(Rails)
      extend ActionSms::Configuration::RailsAdapter
    end
    include ActionSms::Format::PhoneNumber
    include ActionSms::Format::SmsAddress
    include ActionSms::Format::Message
    include ActionSms::Postmaster

    def initialize(*args)
      options = args.last.is_a?(Hash) ? args.last : {}

      [:phone_number, :carrier, :message, :max_length, :split_message].each do |attribute_id|
        self.send :"#{attribute_id}=", options[attribute_id] || options[attribute_id.to_s]
      end
    end

    def valid?
      !!valid_message? && !!valid_sms_address?
    end

    def send_sms(options = {})
      return nil if !valid?

      configure_postmaster unless postmaster_initialized?

      mail_options = options.merge( :to => sms_address, :from => sender_email )

      formatted_messages.each do |message|
        self.postmaster.deliver message, mail_options 
      end
    end

    def sender_email
      @sender_email ||= self.class.sender_email
    end
  end
end
