# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  chatroom_id :integer          not null
#  body        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Message < ActiveRecord::Base
  validates :user_id, :chatroom_id, :body, presence: true
  validates :body, length: {minimum: 1}

  belongs_to :user
  belongs_to :chatroom

  def serialize
    {user_id: self.user_id, body: self.body, created_at: self.created_at}
  end
end
