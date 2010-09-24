module ActionSms
  module Format
    module Message
      attr_accessor :message, :max_length, :split_message

      def formatted_messages
        return nil unless valid_message?
        build_formatted_message_parts
      end

      def max_length
        @max_length ||= 140
      end

      def split_message?
        @split_message ||= false
      end

      def valid_message?
        !empty_message? && !message_too_long?
      end

      private
        def empty_message?
          clean_message.nil? || clean_message.length.zero?
        end

        def message_too_long?
          !split_message? && clean_message.length > max_length
        end

        def build_formatted_message_parts
          return [clean_message] unless split_message?
          clean_message.split(/\s+/).inject([]) do |messages, word|
            last_message = messages.pop
            case
              when last_message.nil? 
                messages.push word
              when last_message.length + word.length < max_length
                messages.push "#{last_message} #{word}"
              else
                messages.push last_message
                messages.push word
            end
          end
        end

        def clean_message
          @message.to_s.strip.gsub(/\s+/, ' ')
        end
    end
  end
end
