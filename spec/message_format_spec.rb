require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe ActionSms::Base do
  context 'formatting the message to send' do
    before :each do
      @instance = ActionSms::Base.new
    end

    it 'should default the max_length to 140' do
      @instance.max_length.should == 140
    end

    it 'should default split_message to false' do
      @instance.should_not be_split_message
    end

    it 'should not be valid if the message is blank' do
      @instance.message = ''
      @instance.should_not be_valid_message
    end

    it 'should not be valid if the message contains only whitespace' do
      @instance.message = "   \t\t   "
      @instance.should_not be_valid_message
    end

    it 'should not be valid if the message is nil' do
      @instance.should_not be_valid_message
    end

    context 'and not splitting the message' do
      before :each do
        @instance.max_length = 10
        @instance.should_not be_split_message
      end

      it 'should not be valid if the message length exceeds the max_length' do
        @instance.message = "The quick brown fox jumped!"
        @instance.should_not be_valid_message
      end

      it 'should not have a formatted_message if the message is invalid' do
        @instance.message = "The quick brown fox jumped!"
        @instance.formatted_messages.should be_nil
      end

      it 'should have only one formatted_message' do
        @instance.message = 'It works!'
        @instance.should have(1).formatted_messages
      end
    end

    context 'and splitting the message' do
      before :each do
        @instance.max_length = 10
        @instance.split_message = true
        @instance.message = "The quick brown fox jumped!"
        @instance.should be_split_message
      end

      it 'should still be valid if the message length exceeds the max_length' do
        @instance.should be_valid_message
      end

      it 'should have at least message length / max_length formatted_messages' do
        minimum_messages = @instance.message.length / @instance.max_length
        @instance.should have_at_least(minimum_messages).formatted_messages
      end

      it 'should split the message on word boundaries' do
        ['quick', 'fox', 'jumped!'].each_with_index do |word, index|
          @instance.formatted_messages[index].split(/\s+/).last.should == word
        end
      end
    end
  end
end
