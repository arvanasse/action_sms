module ActionSms
  module Format
    module PhoneNumber
      attr_accessor :phone_number

      def valid_phone_number?
        exceeds_minimum_phone_length? && proper_phone_format?
      end

      def formatted_phone_number
        @phone_number.gsub(/[-\(\)\s\.a-zA-Z]+/, '').gsub(/^1/, '')
      end

      private
        def exceeds_minimum_phone_length?
          formatted_phone_number.gsub(/\+/, '').length >= 10
        end

        def proper_phone_format?
          formatted_phone_number.match /^[\d|\+]+$/
        end
    end
  end
end
