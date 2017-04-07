# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  chatroom_id :integer          not null
#  body        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  # shoulda_matcher validate_uniqueness_of requires at least one database entry
  before(:all) do
    DatabaseCleaner.clean
    travis = User.create(username: "travis", password: "asdfasdf")
    leo = User.create(username: "leo", password: "asdfasdf")

    chat1 = Chatroom.create(name: "Chatroom 1")

    member1 = ChatroomMember.create(user_id: travis.id, chatroom_id: chat1.id)
    member2 = ChatroomMember.create(user_id: leo.id, chatroom_id: chat1.id)

    message1 = Message.create(user_id: travis.id, chatroom_id: chat1.id, body: "hello Leo")
    message2 = Message.create(user_id: leo.id, chatroom_id: chat1.id, body: "hello Travis")
    message3 = Message.create(user_id: leo.id, chatroom_id: chat1.id, body: "what're you up to?")
    message4 = Message.create(user_id: travis.id, chatroom_id: chat1.id, body: "eating and coding as usual")
  end


  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:chatroom) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:chatroom_id) }
  end

  describe "body attribute" do
    let(:new_message) { Message.new(body: "a", user_id: 1, chatroom_id: 1) }

    it "does not accept a body with less than 1 character" do
      new_message.body = ""
      expect(new_message).not_to be_valid
    end

    it "accepts body with at least 1 character" do
      expect(new_message).to be_valid
    end
    
    it { should validate_presence_of(:body) }
  end

end
