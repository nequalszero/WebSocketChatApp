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
  let!(:travis) { create(:user, username: "travis") }
  let!(:leo) { create(:user, username: "leo") }

  let!(:chat1) { create(:chatroom, name: "Chatroom 1") }

  let!(:member1) { create(:chatroom_member, {user_id: travis.id, chatroom_id: chat1.id}) }
  let!(:member2) { create(:chatroom_member, {user_id: leo.id, chatroom_id: chat1.id}) }

  describe "associations" do
    it { should have_many(:chatroom_members) }
    it { should have_many(:messages) }
    it { should have_many(:users) }
  end

  describe "name validation" do
    let(:new_chatroom) { build(:chatroom, name: "new") }

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

  describe "#get_user_chatroom_membership_id" do
    it "finds the chatroom_member_id of a user" do
      result = chat1.get_user_chatroom_membership_id(leo)
      expect(result).to eq(member2.id)
    end
  end

  describe "#serialize" do
    it "gives the expected result" do
      expected_result = {
        name: chat1.name,
        users: {
          travis.id => travis.username,
          leo.id => leo.username
        },
        id: chat1.id
      }
      result = chat1.serialize

      expect(result).to eq(expected_result)
    end
  end

  describe "#serialize_for_current_user" do
    let(:message1) { create(:message, {user_id: travis.id, chatroom_id: chat1.id, body: "hello Leo"}) }
    let(:message2) { create(:message, {user_id: leo.id, chatroom_id: chat1.id, body: "hello Travis"}) }

    it "gives the expected result" do
      expected_result = {
        name: chat1.name,
        users: {
          travis.id => travis.username,
          leo.id => leo.username
        },
        id: chat1.id,
        membership_id: member2.id,
        messages: [
          {
            user_id: message1.user_id,
            chatroom_id: chat1.id,
            body: message1.body,
            created_at: message1.created_at.to_formatted_s,
            id: message1.id
          },
          {
            user_id: message2.user_id,
            chatroom_id: chat1.id,
            body: message2.body,
            created_at: message2.created_at.to_formatted_s,
            id: message2.id
          }
        ]
      }
      result = chat1.serialize_for_current_user(leo)

      expect(result).to eq(expected_result)
    end
  end

  describe "::non_user_chatrooms" do
    let!(:chat2) { create(:chatroom, name: "Chatroom 2") }
    let!(:chat3) { create(:chatroom, name: "Chatroom 3") }

    let!(:noelle) { create(:user, username: "noelle") }
    let!(:megan) { create(:user, username: "megan") }
    let!(:jerry) { create(:user, username: "jerry") }

    let!(:member3) { create(:chatroom_member, {chatroom_id: chat2.id, user_id: leo.id} ) }
    let!(:member4) { create(:chatroom_member, {chatroom_id: chat2.id, user_id: noelle.id} ) }
    let!(:member5) { create(:chatroom_member, {chatroom_id: chat3.id, user_id: megan.id} ) }
    let!(:member6) { create(:chatroom_member, {chatroom_id: chat3.id, user_id: jerry.id} ) }

    it "gives the proper response" do
      expected_result = [
        {
          name: chat2.name,
          users: {
            leo.id => leo.username,
            noelle.id => noelle.username
          },
          id: chat2.id
        },
        {
          name: chat3.name,
          users: {
            megan.id => megan.username,
            jerry.id => jerry.username
          },
          id: chat3.id
        }
      ]
      result = Chatroom.non_user_chatrooms(travis)

      expect(result).to eq(expected_result)
    end
  end

end
