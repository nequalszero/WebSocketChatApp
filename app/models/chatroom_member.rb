class ChatroomMember < ActiveRecord::Base
  validates :chatroom_id, :user_id, presence: true
  validates :user_id, uniqueness: {scope: :chatroom_id}

  belongs_to :chatroom
  belongs_to :user

  def find_chatroom_member(user_id, chatroom_id)
    ChatroomMember.find_by({user_id: user_id, chatroom_id: chatroom_id})
  end

  def serialize
    { chatroom_id: self.id, user_id: self.user_id, id: id }
  end
end