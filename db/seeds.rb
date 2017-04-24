# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

travis = User.create(username: "travis", password: "asdfasdf")
leo = User.create(username: "leo", password: "asdfasdf")
noelle = User.create(username: "noelle", password: "asdfasdf")
megan = User.create(username: "megan", password: "asdfasdf")
jerry = User.create(username: "jerry", password: "asdfasdf")

chat1 = Chatroom.create(name: "Chatroom 1")
chat2 = Chatroom.create(name: "Chatroom 2")
chat3 = Chatroom.create(name: "Chatroom 3")
chat4 = Chatroom.create(name: "Chatroom 4")
chat5 = Chatroom.create(name: "Chatroom 5")

# Chat1 Members
ChatroomMember.create!(user_id: travis.id, chatroom_id: chat1.id)
ChatroomMember.create!(user_id: leo.id, chatroom_id: chat1.id)

# Chat2 Members
ChatroomMember.create!(user_id: leo.id, chatroom_id: chat2.id)

# Chat3 Members
ChatroomMember.create!(user_id: leo.id, chatroom_id: chat3.id)
ChatroomMember.create!(user_id: noelle.id, chatroom_id: chat3.id)
ChatroomMember.create!(user_id: travis.id, chatroom_id: chat3.id)

# Chat4 Members
ChatroomMember.create!(user_id: leo.id, chatroom_id: chat4.id)
ChatroomMember.create!(user_id: noelle.id, chatroom_id: chat4.id)
ChatroomMember.create!(user_id: travis.id, chatroom_id: chat4.id)
ChatroomMember.create!(user_id: megan.id, chatroom_id: chat4.id)
ChatroomMember.create!(user_id: jerry.id, chatroom_id: chat4.id)

# Chat5 Members
ChatroomMember.create!(user_id: travis.id, chatroom_id: chat5.id)
ChatroomMember.create!(user_id: jerry.id, chatroom_id: chat5.id)

# Chatroom 1 messages
message = Message.create(user_id: travis.id, chatroom_id: chat1.id, body: "hello Leo")
message.update(created_at: 10.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat1.id, body: "hello Travis")
message.update(created_at: 8.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat1.id, body: "what're you up to?")
message.update(created_at: 7.minutes.ago)
message = Message.create(user_id: travis.id, chatroom_id: chat1.id, body: "eating and coding as usual")
message.update(created_at: 5.minutes.ago)

# Chatroom 2 messages
message = Message.create(user_id: leo.id, chatroom_id: chat2.id, body: "I'm so lonely")
message.update(created_at: 5.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat2.id, body: "Oh so lonely")
message.update(created_at: 4.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat2.id, body: "I'm so lonely")
message.update(created_at: 3.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat2.id, body: "Here on my own")
message.update(created_at: 2.minutes.ago)

# Chatroom 3 messages
message = Message.create(user_id: travis.id, chatroom_id: chat3.id, body: "Animal crackers in my soup.")
message.update(created_at: 5.minutes.ago)
message = Message.create(user_id: noelle.id, chatroom_id: chat3.id, body: "Monkeys and rabbits loop de loop.")
message.update(created_at: 4.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat3.id, body: "Gosh oh gee how I have fun.")
message.update(created_at: 3.minutes.ago)
message = Message.create(user_id: noelle.id, chatroom_id: chat3.id, body: "Swallowing animals one by one")
message.update(created_at: 2.minutes.ago)

# Chatroom 4 messages
message = Message.create(user_id: travis.id, chatroom_id: chat4.id, body: "Welcome")
message.update(created_at: 5.minutes.ago)
message = Message.create(user_id: noelle.id, chatroom_id: chat4.id, body: "Hi")
message.update(created_at: 4.minutes.ago)
message = Message.create(user_id: leo.id, chatroom_id: chat4.id, body: "Hello")
message.update(created_at: 3.minutes.ago)
message = Message.create(user_id: megan.id, chatroom_id: chat4.id, body: "Heyy")
message.update(created_at: 2.minutes.ago)
message = Message.create(user_id: jerry.id, chatroom_id: chat4.id, body: "Yo")
message.update(created_at: 1.minutes.ago)

# Chatroom 5 messages
message = Message.create(user_id: travis.id, chatroom_id: chat5.id, body: "What's up Jerry.")
message.update(created_at: 5.minutes.ago)
message = Message.create(user_id: jerry.id, chatroom_id: chat5.id, body: "Climbing on Friday?")
message.update(created_at: 4.minutes.ago)
message = Message.create(user_id: travis.id, chatroom_id: chat5.id, body: "Sure!")
message.update(created_at: 1.minutes.ago)
