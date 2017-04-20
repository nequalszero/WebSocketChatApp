require 'rails_helper'

shared_examples 'verify chatroom membership' do
  it 'responds with a 403 status code' do
    expect(response).to have_http_status(403)
  end

  it 'states that the user does not have access to the chatroom' do
    expect(response.body).to include('Access forbidden - no chatroom access')
  end
end

RSpec.describe Api::MessagesController, type: :controller do
  let!(:user1_credentials) { attributes_for(:user, username: "User 1")}
  let!(:user2_credentials) { attributes_for(:user, username: "User 2")}
  let!(:user1) { create(:user, user1_credentials)}
  let!(:user2) { create(:user, user2_credentials)}

  let!(:chat1) { create(:chatroom) }

  let!(:member1) { create(:chatroom_member, {user_id: user1.id, chatroom_id: chat1.id}) }
  let!(:member2) { create(:chatroom_member, {user_id: user2.id, chatroom_id: chat1.id}) }

  context "when no user is logged in" do
    describe "index method" do
      before(:each) do
        get :index, chatroom_id: chat1.id
      end

      include_examples 'require logged in'
    end

    describe "create method" do
      before(:each) do
        post :create, {chatroom_id: chat1.id, message: {body: "this should not work"}}
      end

      include_examples 'require logged in'
    end

    describe "update method" do
      let(:message1) { create(:message, {user_id: user1.id, chatroom_id: chat1.id}) }

      before(:each) do
        patch :update, {id: message1.id, message: {body: "this should not work"}}
      end

      include_examples 'require logged in'
    end
  end

  context "when the requested chatroom does not exist" do
    describe "index method" do
      before(:each) do
        create_session(user1)
        get :index, chatroom_id: 0
      end

      after(:each) do
        destroy_session
      end

      include_examples 'verify chatroom existance'
    end

    describe "create method" do
      before(:each) do
        create_session(user1)
        post :create, {chatroom_id: 0, message: {body: "this should not work"}}
      end

      after(:each) do
        destroy_session
      end

      include_examples 'verify chatroom existance'
    end
  end

  context "when the logged in user does not belong to the requested chatroom" do
    let!(:user3) { create(:user, username: "User 3") }

    before(:each) do
      create_session(user3)
    end

    after(:each) do
      destroy_session
    end

    describe "index method" do
      before(:each) do
        get :index, {chatroom_id: chat1.id}
      end

      include_examples "verify chatroom membership"
    end

    describe "create method" do
      before(:each) do
        post :create, {chatroom_id: chat1.id}
      end

      include_examples "verify chatroom membership"
    end
  end

  context "index method" do
    let!(:message1) { create(:message, {user_id: user1.id, chatroom_id: chat1.id}) }
    let!(:message2) { create(:message, {user_id: user2.id, chatroom_id: chat1.id}) }

    before(:each) do
      create_session(user1)
      get :index, chatroom_id: chat1.id
    end

    after(:each) do
      destroy_session
    end

    include_examples "responds with a successful status code"

    it "renders a serialized version of the messages belonging to the chatroom" do
      expected_response = [
        {
          user_id: message1.user_id,
          chatroom_id: message1.chatroom_id,
          body: message1.body,
          created_at: message1.created_at.to_formatted_s,
          id: message1.id
        },
        {
          user_id: message2.user_id,
          chatroom_id: message2.chatroom_id,
          body: message2.body,
          created_at: message2.created_at.to_formatted_s,
          id: message2.id
        }
      ].to_json

      expect(response.body).to eq(expected_response)
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
      let(:body) { "this should work" }

      before(:each) do
        post :create, {chatroom_id: chat1.id, message: {body: body}}
      end

      include_examples "responds with a successful status code"

      it "renders a serialized version of the message" do
        message = Message.last
        expect(message).not_to eq(nil)

        expected_response = {
          user_id: user1.id,
          chatroom_id: chat1.id,
          body: body,
          created_at: message.created_at.to_formatted_s,
          id: message.id
        }.to_json

        expect(response.body).to eq(expected_response)
      end
    end

    describe "with invalid parameters" do
      before(:each) do
        post :create, {chatroom_id: chat1.id, message: {body: ""}}
      end

      include_examples "responds with a 422 status code"

      it "states that the body is too short" do
        expect(response.body).to include("Body is too short (minimum is 1 character)")
      end
    end
  end

  context "update method" do
    let(:body) { "initial message" }
    let(:updated_body) { "updated message" }
    let!(:message) { create(:message, {user_id: user1.id, chatroom_id: chat1.id, body: body})}

    before(:each) do
      create_session(user1)
    end

    after(:each) do
      destroy_session
    end

    describe "with valid parameters" do
      before(:each) do
        patch :update, {id: message.id, message: {body: updated_body}}
      end

      include_examples "responds with a successful status code"

      it "renders a serialized version of the updated message" do
        expected_response = {
          user_id: user1.id,
          chatroom_id: chat1.id,
          body: updated_body,
          created_at: message.created_at.to_formatted_s,
          id: message.id
        }.to_json

        expect(response.body).to eq(expected_response)
      end
    end

    describe "with invalid parameters" do
      context "when the message does not exist" do
        before(:each) do
          patch :update, {id: 0, message: {body: ""}}
        end

        include_examples "responds with a 422 status code"

        it "states that the message does not exist" do
          expect(response.body).to include("Unprocessible entity - Message id: 0 does not exist")
        end
      end

      context "when the body is blank" do
        before(:each) do
          patch :update, {id: message.id, message: {body: ""}}
        end

        include_examples "responds with a 422 status code"

        it "states that the body is too short" do
          expect(response.body).to include("Body is too short (minimum is 1 character)")
        end
      end

      context "when the current user is not the original writer of the message" do
        let(:user2_message) { create(:message, {chatroom_id: chat1.id, user_id: user2.id}) }

        before(:each) do
          patch :update, {id: user2_message.id, message: {body: "Should not update"}}
        end

        include_examples "responds with a 403 status code"

        it "states that the update is unauthorized" do
          expected_error_message = "Access forbidden - unauthorized to update message with id: #{user2_message.id}"
          expect(response.body).to include(expected_error_message)
        end
      end
    end
  end

  context "strong parameters" do
    before(:each) do
      create_session(user1)
    end

    after(:each) do
      destroy_session
    end

    it "should only permit body for creation" do
      params = {chatroom_id: chat1.id, message: { body: "hello" }}

      should permit(:body).for(:create, params: params).on(:message)
    end

    it "should only permit body for updating" do
      message = create(:message, {user_id: user1.id, chatroom_id: chat1.id})
      params = {id: message.id, message: { body: "hello", user_id: user2.id }}

      should permit(:body).for(:update, params: params).on(:message)
    end
  end
end
