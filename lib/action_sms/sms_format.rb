module ActionSms
  module Format
    module SmsAddress
      attr_accessor :carrier

      def sms_address
        return nil unless valid_sms_address?
        "#{formatted_phone_number}#{carrier_host}"
      end

      def valid_sms_address?
        valid_carrier? && valid_phone_number?
      end

      private
        def valid_carrier?
          self.class.carriers.keys.include? formatted_carrier
        end

        def formatted_carrier
          carrier_id = @carrier.respond_to?(:to_s) ? @carrier.to_s : @carrier
          carrier_id.downcase
        end

        def carrier_host
          return nil unless valid_carrier?
          current_carrier_attributes['value']
        end

        def current_carrier_attributes
          self.class.carriers[formatted_carrier]
        end
    end
  end
end
