class CreateChatrooms < ActiveRecord::Migration
  def change
    create_table :chatrooms do |t|
      t.string :name, index: true, unique: true, null: false
      t.timestamps null: false
    end
  end
end
