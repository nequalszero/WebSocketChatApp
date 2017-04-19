require 'rails_helper'

RSpec.describe Api::ChatroomMembersController, type: :controller do
  let!(:user1) { create(:user, username: "User 1") }
  let!(:user2) { create(:user, username: "User 2") }
  let!(:chat1) { create(:chatroom, name: "Chatroom 1") }

  context "when no user is logged in" do
    describe "index method" do
      before(:each) do
        get :index, chatroom_id: chat1.id
      end

      include_examples 'require logged in'
    end

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

  context "when the requested chatroom does not exist" do
    before(:each) do
      create_session(user1)
    end

    after(:each) do
      destroy_session
    end

    describe "index method" do
      before(:each) do
        get :index, {chatroom_id: 0}
      end

      include_examples "verify chatroom existance"
    end

    describe "create method" do
      before(:each) do
        post :create, {chatroom_id: 0}
      end

      include_examples "verify chatroom existance"
    end
  end

  context "index method" do
    let!(:member1) { create(:chatroom_member, user_id: user1.id, chatroom_id: chat1.id) }
    let!(:member2) { create(:chatroom_member, user_id: user2.id, chatroom_id: chat1.id) }

    before(:each) do
      create_session(user1)
    end

    after(:each) do
      destroy_session
    end

    describe "with valid parameters" do
      before(:each) do
        get :index, {chatroom_id: chat1.id}
      end

      it "responds with a successful status code" do
        expect(response).to have_http_status(200)
      end

      it "responds with a serialized array of the chatroom's members" do
        expected_response = [
          {
            chatroom_id: member1.chatroom_id,
            user_id: member1.user_id,
            id: member1.id,
            has_left: false
          },
          {
            chatroom_id: member2.chatroom_id,
            user_id: member2.user_id,
            id: member2.id,
            has_left: false
          }
        ].to_json

        expect(response.body).to eq(expected_response)
      end
    end
  end

  context "create method" do
    before(:each) do
      create_session(user1)
    end

    after(:each) do
      destroy_session
    end

    describe "with valid parameters" do
      before(:each) do
        post :create, {chatroom_id: chat1.id}
      end

      it "responds with a successful status code" do
        expect(response).to have_http_status(200)
      end

      it "responds with a serialized version of the chatroom member, with has_left: false" do
        chatroom_member = ChatroomMember.find_chatroom_member(user1.id, chat1.id)
        expected_response = {
          chatroom_id: chat1.id,
          user_id: user1.id,
          id: chatroom_member.id,
          has_left: false
        }.to_json

        expect(response.body).to eq(expected_response)
      end
    end

    describe "when the chatroom member already exists" do
      before(:each) do
        post :create, {chatroom_id: chat1.id}
        post :create, {chatroom_id: chat1.id}
      end

      it "responds with a 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "states that the user has already been taken" do
        expect(response.body).to include("User has already been taken")
      end
    end
  end

  context "destroy method" do
    before(:each) do
      create_session(user1)
    end

    after(:each) do
      destroy_session
    end

    describe "with valid parameters" do
      let!(:member1) { create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id}) }

      before(:each) do |example|
        unless example.metadata[:skip_before]
          delete :destroy, {id: member1.id}
        end
      end

      it "responds with a successful status code" do
        expect(response).to have_http_status(200)
      end

      it "responds with a serialized version of the chatroom member, with has_left: true" do
        chatroom_member = ChatroomMember.find_chatroom_member(user1.id, chat1.id)
        expected_response = {
          chatroom_id: chat1.id,
          user_id: user1.id,
          id: chatroom_member.id,
          has_left: true
        }.to_json

        expect(response.body).to eq(expected_response)
      end

      it "updates the existing entry and does not change the database count", :skip_before do
        old_count = ChatroomMember.count
        delete :destroy, {id: member1.id}
        new_count = ChatroomMember.count
        chatroom_member = ChatroomMember.find_chatroom_member(user1.id, chat1.id)

        expect(chatroom_member.id).to eq(member1.id)
        expect(chatroom_member.has_left).not_to eq(member1.has_left)
        expect(old_count).to eq(new_count)
      end
    end

    describe "with invalid parameters" do
      let!(:member1) { create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id}) }
      let!(:member2) { create(:chatroom_member, {user_id: user2.id, chatroom_id: chat1.id}) }

      context "when the current user does not match the chatroom member" do
        before(:each) do
          delete :destroy, {id: member2.id}
        end

        it "responds with a 403 status code" do
          expect(response).to have_http_status(403)
        end

        it "states that the current user does not match the requested chatroom member" do
          expect(response.body).to include('Unauthorized action - current user is not the chatroom member')
        end
      end

      context "when the requested chatroom member does not exist" do
        before(:each) do
          delete :destroy, {id: 0}
        end

        it "responds with a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "states that the requested chatroom member does not exist" do
          expect(response.body).to include('Unprocessible entity - chatroom member with id: 0 does not exist')
        end
      end
    end
  end
end
