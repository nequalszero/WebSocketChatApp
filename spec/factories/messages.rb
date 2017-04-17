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

FactoryGirl.define do
  factory :message do
    body "Test message body"
    chatroom_id 1
    user_id 1
  end
end
