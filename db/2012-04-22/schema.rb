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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120414075932) do

  create_table "games", :force => true do |t|
    t.string   "city"
    t.string   "place"
    t.date     "date"
    t.time     "time_start"
    t.time     "time_end"
    t.integer  "checked_in", :default => 0
    t.boolean  "opened"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "info_urls", :force => true do |t|
    t.string   "usage",       :null => false
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rounds", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "pair_id"
    t.string   "game_number"
    t.boolean  "varified",       :default => false
    t.integer  "varified_code"
    t.integer  "goals",          :default => 0
    t.integer  "pannas",         :default => 0
    t.boolean  "panna_ko",       :default => false
    t.integer  "fouls",          :default => 0
    t.integer  "flagrant_fouls", :default => 0
    t.boolean  "abstained",      :default => false
    t.integer  "score",          :default => 0
    t.integer  "result",         :default => 0
    t.boolean  "uploaded",       :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "nickname",               :default => "",    :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "phone",                  :default => ""
    t.string   "varified_code",          :default => ""
    t.boolean  "varified",               :default => false
    t.boolean  "admin",                  :default => false
    t.boolean  "subscribed",             :default => false
    t.integer  "grade",                  :default => 0
    t.integer  "scores",                 :default => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["grade"], :name => "index_users_on_grade"
  add_index "users", ["phone"], :name => "index_users_on_phone"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["scores"], :name => "index_users_on_scores"
  add_index "users", ["varified_code"], :name => "index_users_on_varified_code"

end
