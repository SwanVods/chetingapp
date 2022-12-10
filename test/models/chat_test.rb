require "test_helper"

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save chat without message" do
    chat = Chat.new
    assert_not chat.save, "Saved the chat without a message"
  end
end
