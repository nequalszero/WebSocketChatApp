class Chatroom < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 3 }

  has_many :chatroom_members
  has_many :messages
  has_many :users, through: :chatroom_members

  def get_current_user_chatroom_membership_id
    self.chatroom_members.find_by({user_id: current_user.id}).id
  end

  def serialize
    messages = self.messages.map(&:serialize)
    membership_id = self.get_current_user_chatroom_membership_id
    user_directory = {}
    self.users.each { |user| user_directory[user.id] = user.username }
    { name: self.name, messages: messages, users: user_directory, membership_id: membership_id }
  end
end
