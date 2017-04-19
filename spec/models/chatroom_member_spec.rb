# == Schema Information
#
# Table name: chatroom_members
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  chatroom_id          :integer          not null
#  last_message_read_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe ChatroomMember, type: :model do
  let!(:travis) { create(:user, username: "travis") }
  let!(:leo) { create(:user, username: "leo") }

  let!(:chat1) { create(:chatroom, name: "Chatroom 1") }

  let!(:member1) { create(:chatroom_member, user_id: travis.id, chatroom_id: chat1.id) }
  let!(:member2) { create(:chatroom_member, user_id: leo.id, chatroom_id: chat1.id) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:chatroom) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:chatroom_id) }
  end

  describe "a user should not have more than one membership to the same chatroom" do
    it { should validate_uniqueness_of(:user_id).scoped_to(:chatroom_id) }
  end

  describe "::find_chatroom_member" do
    it "finds the correct member given a user id and chatroom id" do
      member = ChatroomMember.find_chatroom_member(leo.id, chat1.id)
      expect(member).to eq(member2)
    end
  end

  describe "#serialize" do
    it "gives the expected response" do
      expected_result = {
        chatroom_id: chat1.id,
        user_id: leo.id,
        id: member2.id,
        has_left: member2.has_left
      }
      result = member2.serialize

      expect(expected_result).to eq(result)
    end
  end

end
