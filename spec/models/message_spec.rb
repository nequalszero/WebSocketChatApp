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
  let!(:travis) { create(:user, username: "travis") }
  let!(:chat1) { create(:chatroom, name: "Chatroom 1") }
  let!(:member1) { create(:chatroom_member, user_id: travis.id, chatroom_id: chat1.id) }
  let(:message1) { create(:message, user_id: travis.id, chatroom_id: chat1.id, body: "hello Leo") }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:chatroom) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:chatroom_id) }
  end

  describe "body attribute" do
    let(:new_message) { build(:message, body: "a", user_id: 1, chatroom_id: 1) }

    it "does not accept a body with less than 1 character" do
      new_message.body = ""
      expect(new_message).not_to be_valid
    end

    it "accepts body with at least 1 character" do
      expect(new_message).to be_valid
    end

    it { should validate_presence_of(:body) }
  end

  describe "#serialize" do
    it "gives the proper response" do
      expected_result = {
        user_id: travis.id,
        chatroom_id: chat1.id,
        body: message1.body,
        created_at: message1.created_at.to_formatted_s,
        id: message1.id
      }
      result = message1.serialize

      expect(result).to eq(expected_result)
    end
  end

end
