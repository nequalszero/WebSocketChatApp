# == Schema Information
#
# Table name: chatroom_members
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  chatroom_id          :integer          not null
#  last_message_read_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ChatroomMember < ActiveRecord::Base
  validates :chatroom_id, :user_id, presence: true
  validates :user_id, uniqueness: {scope: :chatroom_id}

  belongs_to :chatroom
  belongs_to :user

  def self.find_chatroom_member(user_id, chatroom_id)
    ChatroomMember.find_by({user_id: user_id, chatroom_id: chatroom_id})
  end

  def serialize
    { chatroom_id: self.chatroom_id, user_id: self.user_id, id: self.id, has_left: self.has_left }
  end
end
