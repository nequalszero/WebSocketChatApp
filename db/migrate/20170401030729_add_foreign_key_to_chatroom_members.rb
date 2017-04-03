class AddForeignKeyToChatroomMembers < ActiveRecord::Migration
  def change
    add_foreign_key :chatroom_members, :messages, column: :last_message_read_id, primary_key: :id
  end
end
