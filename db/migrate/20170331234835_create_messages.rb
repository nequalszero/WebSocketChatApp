class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :chatroom, index: true, foreign_key: true, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
