class CreateChatroomMembers < ActiveRecord::Migration
  def change
    create_table :chatroom_members do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :chatroom, index: true, foreign_key: true, null: false
      t.references :last_message_read, references: :messages

      t.index [:user_id, :chatroom_id], unique: true
      t.timestamps null: false
    end
  end
end
