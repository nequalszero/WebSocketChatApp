# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user_credentials) { attributes_for(:user, {username: "new", password: "password"}) }
  let!(:new_user) { build(:user, user_credentials) }

  describe "associations" do
    it { should have_many(:chatroom_members) }
    it { should have_many(:messages) }
    it { should have_many(:chatrooms) }
    it { should have_many(:users) }
  end

  describe "password validation" do
    it "does not accept blank passwords" do
      new_user.password = ""
      expect(new_user).not_to be_valid
    end

    it "does not accept short passwords" do
      new_user.password = "short"
      expect(new_user).not_to be_valid
    end

    it "accepts passwords of at least 6 characters" do
      expect(new_user).to be_valid
    end
  end

  describe "username validation" do
    it "does not accept usernames with less than 3 characters" do
      new_user.username = "pi"
      expect(new_user).not_to be_valid
    end

    it "accepts usernames with at least 3 characters" do
      expect(new_user).to be_valid
    end

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it do
      create(:user)
      should validate_uniqueness_of(:username)
    end
  end

  describe "password encryption" do
    it "does not save passwords to the database" do
      create(:user, user_credentials)
      user = User.find_by_username(user_credentials[:username])
      expect(user.password).not_to be(user_credentials[:password])
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      build(:user, user_credentials)
    end
  end

  describe "User::find_by_username_and_credentials" do
    before(:each) do
      create(:user, user_credentials)
    end

    it "returns the correct user when given valid credentials" do
      user = User.find_by_credentials(user_credentials[:username], user_credentials[:password])
      expect(user.class).to eq(User)
      expect(user.username).to eq(user_credentials[:username])
    end

    it "returns nil when given invalid credentials" do
      user = User.find_by_credentials(user_credentials[:username], "wrong_password")
      expect(user.class).to eq(NilClass)
    end
  end
end
