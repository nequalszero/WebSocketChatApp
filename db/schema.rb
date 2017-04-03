# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170401030729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chatroom_members", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "chatroom_id",          null: false
    t.integer  "last_message_read_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "chatroom_members", ["chatroom_id"], name: "index_chatroom_members_on_chatroom_id", using: :btree
  add_index "chatroom_members", ["user_id", "chatroom_id"], name: "index_chatroom_members_on_user_id_and_chatroom_id", unique: true, using: :btree
  add_index "chatroom_members", ["user_id"], name: "index_chatroom_members_on_user_id", using: :btree

  create_table "chatrooms", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chatrooms", ["name"], name: "index_chatrooms_on_name", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "chatroom_id", null: false
    t.text     "body",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "messages", ["chatroom_id"], name: "index_messages_on_chatroom_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "password_digest", null: false
    t.string   "session_token",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  add_foreign_key "chatroom_members", "chatrooms"
  add_foreign_key "chatroom_members", "messages", column: "last_message_read_id"
  add_foreign_key "chatroom_members", "users"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
end
