require 'rails_helper'

RSpec.describe Api::ChatroomMembersController, type: :controller do
  let!(:user1) { create(:user, username: "User 1") }
  let!(:user2) { create(:user, username: "User 2") }
  let!(:chat1) { create(:chatroom, name: "Chatroom 1") }

  context "when no user is logged in" do
    describe "#index" do
      before(:each) do
        get :index, chatroom_id: chat1.id
      end

      include_examples 'require logged in'
    end

    describe "#create" do
      before(:each) do
        post :create, chatroom_id: chat1.id
      end

      include_examples 'require logged in'
    end

    describe "#destroy" do
      before(:each) do
        delete :destroy, id: 0
      end

      include_examples 'require logged in'
    end
  end

  context "when the requested chatroom does not exist" do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(user1)
    end

    describe "#index" do
      before(:each) do
        get :index, {chatroom_id: 0}
      end

      include_examples "verify chatroom existance"
    end

    describe "#create" do
      before(:each) do
        post :create, {chatroom_id: 0}
      end

      include_examples "verify chatroom existance"
    end
  end

  context "#index" do
    let!(:member1) { create(:chatroom_member, user_id: user1.id, chatroom_id: chat1.id) }
    let!(:member2) { create(:chatroom_member, user_id: user2.id, chatroom_id: chat1.id) }

    before(:each) do
      allow(controller).to receive(:current_user).and_return(user1)
    end

    describe "with valid parameters" do
      before(:each) do
        get :index, {chatroom_id: chat1.id}
      end

      include_examples "responds with a successful status code"

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

  context "#create" do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(user1)
    end

    describe "with valid parameters" do
      let(:expected_response) {
        JSON.parse({
          name: chat1.name,
          users: {
            user1.id => user1.username,
            user2.id => user2.username
          },
          id: chat1.id,
          membership_id: nil,
          messages: []
        }.to_json)
      }

      context "when the user has never been a part of the chatroom" do
        before(:each) do |example|
          unless example.metadata[:skip_before]
            post :create, {chatroom_id: chat1.id}
          end
        end

        include_examples "responds with a successful status code"

        it "creates a new entry in the chatroom_members table", :skip_before do
          old_count = ChatroomMember.count
          post :create, {chatroom_id: chat1.id}

          expect(Chatroom.count).to eq(old_count + 1)
        end

        it "saves the new chatroom_member with attribute has_left: false" do
          chatroom_member = ChatroomMember.find_by({user_id: user1.id, chatroom_id: chat1.id})

          expect(chatroom_member).not_to eq(nil)
          expect(chatroom_member.has_left).to eq(false)
        end

        it "responds with a serialized version of the chatroom", :skip_before do
          create(:chatroom_member, {user_id: user2.id, chatroom_id: chat1.id, has_left: true})
          post :create, {chatroom_id: chat1.id}

          chatroom_member = ChatroomMember.find_by({user_id: user1.id, chatroom_id: chat1.id})
          expected_response["membership_id"] = chatroom_member.id

          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context "when the user was once a member of the chatroom" do
        before(:each) do |example|
          unless example.metadata[:skip_before]
            create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id, has_left: true})
            post :create, {chatroom_id: chat1.id}
          end
        end

        include_examples "responds with a successful status code"

        it "does not create a new entry in the chatroom_members table", :skip_before do
          create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id, has_left: true})
          old_count = ChatroomMember.count
          post :create, {chatroom_id: chat1.id}

          expect(ChatroomMember.count).to eq(old_count)
        end

        it "updates the existing chatroom_member with attribute has_left: false" do
          chatroom_member = ChatroomMember.find_by({user_id: user1.id, chatroom_id: chat1.id})

          expect(chatroom_member).not_to eq(nil)
          expect(chatroom_member.has_left).to eq(false)
        end

        it "responds with a serialized version of the chatroom", :skip_before do
          create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id, has_left: true})
          create(:chatroom_member, {user_id: user2.id, chatroom_id: chat1.id, has_left: true})
          post :create, {chatroom_id: chat1.id}

          chatroom_member = ChatroomMember.find_by({user_id: user1.id, chatroom_id: chat1.id})
          expected_response["membership_id"] = chatroom_member.id

          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end

    describe "when the chatroom member already exists and has not left" do
      before(:each) do
        post :create, {chatroom_id: chat1.id}
        post :create, {chatroom_id: chat1.id}
      end

      include_examples "responds with a 422 status code"

      it "states that the user has already been taken" do
        expect(response.body).to include("Unprocessible entity - user is still a member of the chatroom, cannot re-add")
      end
    end
  end

  context "#destroy" do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(user1)
    end

    describe "with valid parameters" do
      let!(:member1) { create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id}) }

      before(:each) do |example|
        unless example.metadata[:skip_before]
          delete :destroy, {id: member1.id}
        end
      end

      include_examples "responds with a successful status code"

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

        include_examples "responds with a 403 status code"

        it "states that the current user does not match the requested chatroom member" do
          expect(response.body).to include('Unauthorized action - current user is not the chatroom member')
        end
      end

      context "when the requested chatroom member does not exist" do
        before(:each) do
          delete :destroy, {id: 0}
        end

        include_examples "responds with a 422 status code"

        it "states that the requested chatroom member does not exist" do
          expect(response.body).to include('Unprocessible entity - chatroom member with id: 0 does not exist')
        end
      end
    end
  end
end
