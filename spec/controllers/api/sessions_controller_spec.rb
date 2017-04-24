require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  describe "creating a session" do
    let(:user_credentials) { attributes_for(:user, {username: "new_user", password: "password"}) }
    let!(:user) { create(:user, user_credentials) }

    context "with valid params" do
      before(:each) do
        post :create, user: user_credentials
      end

      after(:each) do
        delete :destroy
      end

      include_examples "responds with a successful status code"

      it "successfully logs in the user" do
        expect(current_user.id).to eq(user.id)
      end

      it "gives the expected response" do
        expected_response = {username: user.username, id: user.id, chatrooms: [], nonUserChatrooms: []}.to_json
        expect(response.body).to eq(expected_response)
      end

      it "assigns a new session_token to the database and cookie" do
        expect(session[:session_token]).to eq(current_user.session_token)
      end
    end

    context "with invalid params" do
      before(:each) do
        user_credentials[:password] = "wrong password"
        post :create, user: user_credentials
      end

      include_examples "responds with a 401 status code"

      it "states that the username/password combination is invalid" do
        expect(response.body).to include("Invalid username/password combination")
      end
    end
  end

  describe "destroying a session" do
    context "when there is an active session" do
      let(:user_credentials) { attributes_for(:user, {username: "new_user", password: "password"}) }
      let!(:user) { create(:user, user_credentials) }

      before(:each) do
        post :create, user: user_credentials
        delete :destroy
      end

      include_examples "responds with a successful status code"

      it "successfully logs out current user" do
        expect(current_user).to eq(nil)
      end

      it "gives the expected response" do
        expected_destroy_response = {username: user.username, id: user.id}.to_json
        expect(response.body).to eq(expected_destroy_response)
      end

      it "clears the session_token in the client's cookie" do
        expect(session[:session_token]).to eq(nil)
      end

      it "resets the session_token in the database" do
        post :create, user: user_credentials
        old_session_token = User.find(user.id).session_token
        delete :destroy
        new_session_token = User.find(user.id).session_token
        expect(new_session_token).not_to eq(old_session_token)
      end
    end

    context "when there is no active session" do
      before(:each) do
        delete :destroy
      end

      include_examples 'require logged in'
    end
  end
end
