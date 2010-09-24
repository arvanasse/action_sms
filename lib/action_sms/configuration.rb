module ActionSms
  module Configuration
    module Base
      attr_accessor :sender_email, :carriers, :mail_settings
      attr_accessor :mailer_initialized

      class << self
        def extended(receiver)
          default_configuration_path = File.join(File.dirname(__FILE__), 'sms_fu.yml')
          receiver.import_configuration default_configuration_path 
          receiver.send(:set_mailer_flag)
        end
      end
    
      def import_configuration(configuration_path)
        import_carriers configuration_path
        import_sender_email configuration_path
        import_mail_settings configuration_path
      end

      private
        def set_mailer_flag
          mailer_initialized ||= false
        end

        def import_carriers(path)
          read_configuration(path) do |configuration|
            self.carriers = configuration['carriers']
          end
        end

        def import_sender_email(path)
          read_configuration (path) do |configuration|
            self.sender_email = configuration['config']['from_address']
          end
        end

        def import_mail_settings(path)
          read_configuration (path) do |configuration|
            self.mail_settings = configuration['mail_settings']
          end
        end

        def read_configuration(path)
          require 'yaml'
          File.open path do |config_file|
            yield YAML.load(config_file)
          end
        end
    end

    module RailsAdapter
      class << self
        def extended(receiver)
          rails_configuration_path = File.join(Rails.root, 'config', 'sms_fu.yml')
          receiver.import_configuration rails_configuration_path 
        end
      end
    end
  end
end
