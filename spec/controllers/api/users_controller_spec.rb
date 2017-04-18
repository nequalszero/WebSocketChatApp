require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe "creating a user" do
    context "with valid params" do
      before(:each) do
        post :create, user: { username: "new_username", password: "password" }
      end

      let(:user) { User.find_by_username("new_username") }
      let(:expected_response) { {username: user.username, id: user.id, chatrooms: []}.to_json }

      it "reponds with a successful status code" do
        expect(response).to have_http_status(200)
      end

      it "renders a JSON object with the correct information" do
        expect(user).not_to eq(nil)
        expect(response.body).to eq(expected_response)
      end
    end

    context "with invalid params" do
      describe "validates the presence of a username" do
        before(:each) do
          post :create, user: { password: "password" }
        end

        it "responds with a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "states that the username field cannot be blank" do
          expect(response.body).to include("Username can't be blank")
        end
      end

      describe "validates that usernames must be at least 3 characters" do
        before(:each) do
          post :create, user: { username: "pi" , password: "password"}
        end

        it "responds with a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "states that usernames must be at least 3 characters" do
          expect(response.body).to include("Username is too short (minimum is 3 characters)")
        end
      end

      describe "validates that usernames must be unique" do
        before(:each) do
          create(:user, username: "unique_username")
          post :create, user: { username: "unique_username" , password: "something"}
        end

        it "responds with a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "states that the password field cannot be blank" do
          expect(response.body).to include("Username has already been taken")
        end
      end

      describe "validates the presence of a password" do
        before(:each) do
          post :create, user: { username: "test" }
        end

        it "responds with a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "states that the password field cannot be blank" do
          expect(response.body).to include("Password digest can't be blank")
        end
      end

      describe "validates that passwords must be at least 6 characters" do
        before(:each) do
          post :create, user: { username: "test", password: "short"}
        end

        it "responds with a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "states that passwords must be at least 6 characters" do
          expect(response.body).to include("Password is too short (minimum is 6 characters)")
        end
      end
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
      should permit(:username, :password).for(:create, params: params).on(:user)
    end
  end
end
