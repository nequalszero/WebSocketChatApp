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

FactoryGirl.define do
  factory :chatroom_member do
    user_id 1
    chatroom_id 1
  end
end
