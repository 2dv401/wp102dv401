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

ActiveRecord::Schema.define(:version => 20130110102709) do

  create_table "followers", :force => true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "follows", :force => true do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "likes", :force => true do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], :name => "fk_likeables"
  add_index "likes", ["liker_id", "liker_type"], :name => "fk_likes"

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
    t.boolean  "gmaps",                        :default => true,  :null => false
  end

  create_table "locations_maps", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "map_id"
  end

  add_index "locations_maps", ["location_id", "map_id"], :name => "index_locations_maps_on_location_id_and_map_id"

  create_table "maps", :force => true do |t|
    t.string   "name",        :limit => 50,                     :null => false
    t.text     "description", :limit => 256,                    :null => false
    t.float    "longitude",                                     :null => false
    t.float    "latitude",                                      :null => false
    t.boolean  "private",                    :default => false, :null => false
    t.boolean  "gmaps",                      :default => true,  :null => false
    t.integer  "user_id",                                       :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "status_comments", :force => true do |t|
    t.integer  "user_id",                                          :null => false
    t.integer  "status_update_id",                                 :null => false
    t.string   "content",          :limit => 5120, :default => "", :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "status_comments", ["user_id", "status_update_id"], :name => "index_status_comments_on_user_id_and_status_update_id"

  create_table "status_updates", :force => true do |t|
    t.string   "content",    :limit => 5120, :default => "", :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "map_id"
    t.integer  "user_id"
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
    t.string   "profile_image"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
