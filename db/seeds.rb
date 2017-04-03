# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

travis = User.create(username: "travis", password: "asdfasdf")
leo = User.create(username: "leo", password: "asdfasdf")

chat1 = Chatroom.create(name: "Chatroom 1")

ChatroomMember.create(user_id: travis.id, chatroom_id: chat1.id)
ChatroomMember.create(user_id: leo.id, chatroom_id: chat1.id)

message = Message.create(user_id: travis.id, chatroom_id: chat1.id, body: "hello Leo")
message.update(created_at: 10.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat1.id, body: "hello Travis")
message.update(created_at: 8.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat1.id, body: "what're you up to?")
message.update(created_at: 7.minutes.ago)
message = Message.create(user_id: travis.id, chatroom_id: chat1.id, body: "eating and coding as usual")
message.update(created_at: 5.minutes.ago)
