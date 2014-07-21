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

ActiveRecord::Schema.define(version: 20140714102542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: true do |t|
    t.text     "reply"
    t.integer  "user_id_fk"
    t.integer  "message_id_fk"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "sender"
    t.integer  "receiver"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.integer  "user_id"
    t.string   "shop_name"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
    t.string   "shop_name"
  end

end
