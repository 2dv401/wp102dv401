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
ActiveRecord::Schema.define(:version => 20121215093740) do
  create_table "location_images", :force => true do |t|
    t.string   "file_name",   :limit => 32,  :null => false
    t.text     "description", :limit => 256, :null => false
    t.integer  "location_id",                :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "location_types", :force => true do |t|
    t.string   "name",       :limit => 45, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name",          :limit => 32,                     :null => false
    t.string   "description",   :limit => 256
    t.float    "longitude",                                       :null => false
    t.float    "latitude",                                        :null => false
    t.datetime "date"
    t.boolean  "private",                      :default => false, :null => false
    t.integer  "place_type_id",                                   :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "map_locations", :id => false, :force => true do |t|
    t.integer "map_id"
    t.integer "location_id"
  end

  create_table "maps", :force => true do |t|
    t.string   "name",        :limit => 50,                    :null => false
    t.text     "description", :limit => 256,                   :null => false
    t.float    "longitude",                                    :null => false
    t.float    "latitude",                                     :null => false
    t.boolean  "private",                                      :null => false
    t.boolean  "gmaps",                      :default => true, :null => false
    t.integer  "user_id",                                      :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "twitter_handle"
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_secret"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["twitter_handle"], :name => "index_users_on_twitter_handle", :unique => true
  add_index "users", ["twitter_oauth_token", "twitter_oauth_secret"], :name => "index_users_on_twitter_oauth_token_and_twitter_oauth_secret"

end
