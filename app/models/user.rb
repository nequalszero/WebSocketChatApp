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

class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :username, length: { minimum: 3 }

  attr_reader :password

  has_many :chatroom_members
  has_many :messages
  has_many :chatrooms, through: :chatroom_members
  has_many :users, through: :chatroom_members

  after_initialize :ensure_session_token

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil unless user && user.valid_password?(password)
    user
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def serialize
    {username: self.username, id: self.id}
  end

  # Returns an object with the following structure
  # {:username=>"travis",
  #  :id=>1,
  #  :chatrooms=>
  #   [{ :name=>"Chatroom 1"
  #      :users=>{1=>"travis", 2=>"leo"},
  #      :messages=>
  #        [ {:user_id=>1,
  #           :body=>"hello Leo",
  #           :created_at=>Mon, 03 Apr 2017 19:43:13 UTC +00:00},
  #           .
  #           .
  #           .
  #          {:user_id=>1,
  #           :body=>"eating and coding as usual",
  #           :created_at=>Mon, 03 Apr 2017 19:48:13 UTC +00:00} ]
  #   }]
  # }
  def serialize_current_user
    user = User.includes(:chatrooms).includes(:chatroom_members).includes(:messages).includes(:users).find_by(id: self.id)
    user_chatrooms = self.chatrooms.map { |chatroom| chatroom.serialize_for_current_user }
    {username: self.username, id: self.id, chatrooms: user_chatrooms }
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
end
