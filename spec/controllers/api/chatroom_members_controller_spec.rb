require 'rails_helper'

RSpec.describe Api::ChatroomMembersController, type: :controller do
  let!(:user1) { create(:user, username: "User 1") }
  let!(:user2) { create(:user, username: "User 2") }
  let!(:chat1) { create(:chatroom, name: "Chatroom 1") }

  context "when no user is logged in" do
    describe "create method" do
      before(:each) do
        post :create, chatroom_id: chat1.id
      end

      include_examples 'require logged in'
    end

    describe "destroy method" do
      before(:each) do
        delete :destroy, id: 0
      end

      include_examples 'require logged in'
    end
  end
end
