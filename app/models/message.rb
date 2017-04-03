class Message < ActiveRecord::Base
  validates :user_id, :chatroom_id, :body, presence: true
  validates :body, length: {minimum: 1}

  belongs_to :user
  belongs_to :chatroom

  def serialize
    {user_id: self.user_id, body: self.body, created_at: self.created_at}
  end
end
