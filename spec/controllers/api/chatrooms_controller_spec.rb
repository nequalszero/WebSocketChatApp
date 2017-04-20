require 'rails_helper'

RSpec.describe Api::ChatroomsController, type: :controller do
  let(:user) { create(:user) }

  context "when no user is logged in" do
    describe "index method" do
      before(:each) do
        get :index
      end

      include_examples 'require logged in'
    end

    describe "create method" do
      before(:each) do
        post :create, chatroom: {name: "Chatroom 1"}
      end

      include_examples 'require logged in'
    end
  end

  context "when a user is logged in" do
    before(:each) do
      create_session(user)
    end

    after(:each) do
      destroy_session
    end

    describe "index method" do
      let(:room1) { create(:chatroom, name: "Room 1") }
      let!(:room2) { create(:chatroom, name: "Room 2") }

      before(:each) do
        create(:chatroom_member, {chatroom_id: room1.id, user_id: user.id})
        get :index
      end

      include_examples "responds with a successful status code"

      it "does not retrieve chatrooms that the user is already a member of" do
        parsed_response = JSON.parse(response.body)
        expected_response = [JSON.parse(room2.serialize.to_json)]

        expect(parsed_response).to eq(expected_response)
      end
    end

    describe "creating a chatroom" do
      context "with valid params" do
        before(:each) do
          post :create, chatroom: { name: "chatroom 1" }
        end

        let(:chatroom) { Chatroom.find_by({name: "chatroom 1"}) }
        let(:chatroom_member) { ChatroomMember.find_by({user_id: user.id, chatroom_id: chatroom.id}) }

        include_examples "responds with a successful status code"

        it "creates a chatroom in the database" do
          expect(chatroom).not_to eq(nil)
        end

        it "adds the chatroom creator to the ChatroomMember table" do
          expect(chatroom_member).not_to eq(nil)
        end
      end

      context "with invalid params" do
        describe "does not allow chatrooms with duplicate names" do
          before(:each) do
            post :create, chatroom: { name: "chatroom 1" }
            post :create, chatroom: { name: "chatroom 1" }
          end

          include_examples "responds with a 422 status code"

          it "should state that the name has already been taken" do
            expect(response.body).to include("Name has already been taken")
          end
        end

        describe "does not allow chatrooms without a name" do
          before(:each) do
            post :create, chatroom: { name: nil }
          end

          include_examples "responds with a 422 status code"

          it "should state that the name cannot be blank" do
            expect(response.body).to include("Name can't be blank")
          end
        end

        describe "does not allow chatrooms with names that are less than 3 characters" do
          before(:each) do
            post :create, chatroom: { name: "hi" }
          end
          
          include_examples "responds with a 422 status code"

          it "should state that the name is too short" do
            expect(response.body).to include("Name is too short (minimum is 3 characters)")
          end
        end
      end
    end
  end

end
