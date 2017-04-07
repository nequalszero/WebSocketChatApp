# == Schema Information
#
# Table name: chatrooms
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Chatroom, type: :model do
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
    it { should have_many(:chatroom_members) }
    it { should have_many(:messages) }
    it { should have_many(:users) }
  end

  describe "name validation" do
    let(:new_chatroom) { Chatroom.new(name: "new") }

    it "does not accept names with less than 3 characters" do
      new_chatroom.name = "pi"
      expect(new_chatroom).not_to be_valid
    end

    it "accepts names with at least 3 characters" do
      expect(new_chatroom).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

end
