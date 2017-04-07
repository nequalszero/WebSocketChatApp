require 'rails_helper'
include Api::SessionsHelper

RSpec.describe Api::ChatroomsController, type: :controller do
  before(:all) do
    DatabaseCleaner.clean
    User.create!({username: "travis", password: "asdfasdf"})
  end

  user = User.find_by_username("travis")

  context "with valid params" do
    # before(:all) loop doesn't work for some reason, gives a nil:NilClass error
    # => when trying to set the session cookie
    done = false
    before(:each) do
      # self.class inside create_session gives
      #   RSpec::ExampleGroups::ApiChatroomsController::WithValidParams
      until done do
        create_session(user)
        post :create, chatroom: { name: "chatroom 1" }
        done = true
      end
    end

    let(:chatroom) { Chatroom.find_by({name: "chatroom 1"}) }
    let(:chatroom_member) { ChatroomMember.find_by({user_id: user.id, chatroom_id: chatroom.id}) }

    it "responds with a successful status code" do
      expect(response).to have_http_status(200)
    end

    it "creates a chatroom in the database" do
      expect(chatroom).not_to eq(nil)
    end

    it "adds the chatroom creator to the ChatroomMember table" do
      expect(chatroom_member).not_to eq(nil)
    end
  end

end
