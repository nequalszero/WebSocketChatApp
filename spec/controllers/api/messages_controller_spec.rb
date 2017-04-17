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
        patch :update, {id: message1.id, chatroom_id: chat1.id, message: {body: "this should not work"}}
      end

      include_examples 'require logged in'
    end
  end

  context "when the logged in user does not belong to the chatroom" do
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

    describe "update method" do
      let(:message1) { create(:message, {user_id: user1.id, chatroom_id: chat1.id}) }

      before(:each) do
        patch :update, {chatroom_id: chat1.id, id: message1.id}
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

    it "responds with a successful status code" do
      expect(response).to have_http_status(200)
    end

    it "gives the expected response" do
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

  # context "strong parameters" do
  #   before(:each) do
  #     create_session(user1)
  #   end
  #
  #   after(:each) do
  #     destroy_session
  #   end
  #
  #   it "should only permit body" do
  #     params = {chatroom_id: chat1.id, message: { body: "hello" }}
  #     should permit(:body, :user_id, :chatroom_id).for(:create, params: params)
  #     should permit(:body, :user_id, :chatroom_id).for(:update, params: params)
  #   end
  # end
end
