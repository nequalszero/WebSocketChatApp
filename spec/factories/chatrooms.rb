# == Schema Information
#
# Table name: chatrooms
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :chatroom do
    name "Chatroom 1"
  end
end
