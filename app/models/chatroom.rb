# == Schema Information
#
# Table name: chatrooms
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chatroom < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 3 }

  has_many :chatroom_members
  has_many :messages
  has_many :users, through: :chatroom_members

  # Gets all chatrooms
  def self.all_chatrooms_with_users
    chatrooms = Chatroom.includes(:messages).includes(:chatroom_members).includes(:users).all
    chatrooms.map(&:serialize)
  end

  # finds the chatroom member id for the current user
  def get_current_user_chatroom_membership_id
    self.chatroom_members.find_by({user_id: current_user.id}).id
  end

  # Grabs basic chatroom information (name, members) without the messages
  def serialize
    user_directory = {}
    self.users.each { |user| user_directory[user.id] = user.username }
    { name: self.name, users: user_directory }
  end

  # Adds membership_id key in case current user wants to leave chatroom => destroy chatroom_member
  def serialize_for_current_user
    reponse = self.serialize
    response[:membership_id] = self.get_current_user_chatroom_membership_id
    response[:messages] = self.messages.map(&:serialize)
  end
end
