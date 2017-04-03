class Chatroom < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 3 }

  has_many :chatroom_members
  has_many :messages
  has_many :users, through: :chatroom_members

  def serialize
    messages = self.messages.map(&:serialize)
    user_directory = {}
    self.users.each { |user| user_directory[user.id] = user.username }
    { name: self.name, messages: messages, users: user_directory }
  end
end
