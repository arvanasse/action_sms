module ActionSms
  module Postmaster
    attr_reader :postmaster, :delivery_method

    def configure_postmaster
      mail_settings = self.class.mail_settings.inject({}) do |settings, (attr, val)|
        settings.merge attr.to_sym => val
      end


      @postmaster = case mail_settings[:delivery_method]
        when :postmark then ActionSms::Postmaster::PostmarkAdapter.new(mail_settings)
        else                ActionSms::Postmaster::MailAdapter.new(mail_settings)
      end
    end

    def postmaster_initialized?
      !@postmaster.nil?
    end

    class MailAdapter
      def initialize(options = {})
        unless @delivery_method = options.delete(:delivery_method)
          raise ArgumentError, "Must define the delivery method"
        end

        Mail.defaults do
          delivery_method @delivery_method, options
        end
      end

      def deliver(message, options={})
        validate_delivery_options options
        Mail.deliver do  
          to options[:to]
          from options[:from]
          body message
        end
      end

      private
        def validate_delivery_options( options = {} )
          [:to, :from].each do |required_option| 
            unless options.include?(required_option)
              raise ArgumentError, "Must provide #{required_option} option" 
            end
          end
        end
    end

    class PostmarkAdapter
      def initialize(options = {})
        require 'tmail'
        require 'postmark'

        Postmark.api_key = options[:api_key]
      end

      def deliver(message, options = {})
        validate_delivery_options options

        outgoing_mail = TMail::Mail.new
        outgoing_mail.from = options[:from]
        outgoing_mail.to = options[:to] 
        outgoing_mail.body = message
        outgoing_mail.content_type = 'text/plain'

        outgoing_mail.tag = options[:tag] if options[:tag]

        Postmark.send_through_postmark outgoing_mail
      end

      private
        def validate_delivery_options( options = {} )
          [:to, :from].each do |required_option| 
            unless options.include?(required_option)
              raise ArgumentError, "Must provide #{required_option} option" 
            end
          end
        end
    end
  end
end
