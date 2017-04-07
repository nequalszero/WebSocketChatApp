require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  before(:all) do
    DatabaseCleaner.clean
  end

  context "with valid params" do
    it "validates user with valid parameters" do
      post :create, user: { username: "new_username", password: "password" }
      user = User.find_by_username("new_username")
      expected_response = {username: user.username, id: user.id, chatrooms: []}.to_json

      expect(response).to have_http_status(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "with invalid params" do
    it "validates that username and password cannot be blank" do
      post :create, user: { username: "", password: ""}
      expect(response).to have_http_status(422)
    end

    it "validates the presence of a username" do
      post :create, user: { password: "password" }
      expect(response).to have_http_status(422)
    end

    it "validates that usernames cannot be blank" do
      post :create, user: { username: "", password: "password"}
      expect(response).to have_http_status(422)
    end

    it "validates that usernames must be at least 3 characters" do
      post :create, user: { username: "pi" , password: "password"}
      expect(response).to have_http_status(422)
    end

    it "validates that usernames must be unique" do
      User.create(username: "unique_username", password: "password")
      post :create, user: { username: "unique_username" , password: "something"}
      expect(response).to have_http_status(422)
    end

    it "validates the presence of a password" do
      post :create, user: { username: "test" }
      expect(response).to have_http_status(422)
    end

    it "validates that passwords cannot be blank" do
      post :create, user: { username: "test", password: ""}
      expect(response).to have_http_status(422)
    end

    it "validates that passwords must be at least 6 characters" do
      post :create, user: { username: "test", password: "short"}
      expect(response).to have_http_status(422)
    end
  end

  context "strong parameters" do
    it "user_params only allows username and password" do
      post :create, user: { username: "hacker", password: "password", password_digest: "abc123", session_token: "apples" }
      user = User.find_by_credentials("hacker", "password")

      expect(user).not_to eq(nil)
      expect(user.password_digest).not_to eq("abc123")
      expect(user.session_token).not_to eq("apples")
    end

    it "should only permit username and password" do
      params = {user: { username: "hacker", password: "password", password_digest: "abc123", session_token: "apples" }}
      should permit(:username, :password).for(:create, params: params)
    end
  end
end
