require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  # Clear out the test database

  # Create a user
  new_username = "new_user"
  new_password = "password"
  valid_user = { username: new_username, password: new_password }

  before(:all) do
    DatabaseCleaner.clean
    User.create!(valid_user)
  end

  describe "with valid_params" do
    before(:each) do
      post :create, user: valid_user
      puts "creating valid user"
    end

    let(:user) { User.find_by_username(new_username) }
    let(:expected_create_response) { {username: user.username, id: user.id, chatrooms: []}.to_json }
    let(:expected_destroy_response) { {username: user.username, id: user.id}.to_json }

    context "creating a session" do
      it "responds with a successful status code" do
        puts "running first session controller test"
        expect(response).to have_http_status(200)
      end

      it "gives the expected response" do
        expect(response.body).to eq(expected_create_response)
      end

      it "assigns a session_token to the database and cookie" do
        expect(session[:session_token]).to eq(user.session_token)
      end
    end

    context "destroying a session" do
      before(:each) do
        post :destroy
      end

      it "successfully logs out user" do
        expect(response).to have_http_status(200)
      end

      it "gives the expected response" do
        expect(response.body).to eq(expected_destroy_response)
      end

      it "clears the session_token in the client's cookie" do
        expect(session[:session_token]).to eq(nil)
      end

      it "resets the session_token in the database" do
        post :create, user: valid_user
        old_session_token = User.find_by_username(new_username).session_token
        post :destroy
        new_session_token = User.find_by_username(new_username).session_token
        expect(new_session_token).not_to eq(old_session_token)
      end
    end
  end

  describe "with invalid params" do
    context "creating a session" do
      it "responds with a 401 status code" do
        post :create, user: { username: new_username, password: "wrong_password"}
        expect(response).to have_http_status(401)
      end
    end
    context "destroying a session" do
      it "responds with a 404 status code" do
        post :destroy
        expect(response).to have_http_status(404)
      end
    end
  end
end
