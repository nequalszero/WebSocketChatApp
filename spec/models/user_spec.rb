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
  # shoulda_matcher validate_uniqueness_of requires at least one database entry
  test_username = "test_user"
  test_password = "password"

  before(:all) do
    DatabaseCleaner.clean
    puts "User model: After delete: #{User.count} entries in database"

    User.create!({username: test_username, password: test_password})
    puts "User model after create: #{User.count} entries in database"
  end
  
  let(:new_user) { User.new(username: "new", password: "password") }

  describe "password validation" do
    it "does not accept blank passwords" do
      puts "running first user model test"
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
    it { should validate_uniqueness_of(:username) }
  end

  describe "password encryption" do
    it "does not save passwords to the database" do
      User.create!(username: "leo", password: "asdfasdf")
      user = User.find_by_username("leo")
      expect(user.password).not_to be("asdfasdf")
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: "leo", password: "asdfasdf")
    end
  end

  describe "User#find_by_username_and_credentials" do
    it "returns a user when given valid credentials" do
      user = User.find_by_credentials(test_username, test_password)
      expect(user.class).not_to eq(NilClass)
      expect(user.class).to eq(User)
    end

    it "returns nil when given invalid credentials" do
      user = User.find_by_credentials(test_username, "wrong_password")
      expect(user.class).to eq(NilClass)
      expect(user.class).not_to eq(User)
    end
  end

  # DatabaseCleaner.clean
end
