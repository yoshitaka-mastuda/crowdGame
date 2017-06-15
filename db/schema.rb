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

ActiveRecord::Schema.define(version: 20170614101405) do

  create_table "tweets", force: :cascade do |t|
    t.text "text"
    t.integer "tweet_id", precision: 38
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", precision: 38
    t.integer "twitter_user_id", precision: 38
    t.boolean "confirm", default: false
    t.boolean "pending", default: true
    t.integer "reject_count", precision: 38, default: 0
    t.integer "accept_count", precision: 38, default: 0
    t.integer "votes_count", precision: 38, default: 0
    t.index ["confirm", "user_id"], name: "i_tweets_confirm_user_id"
    t.index ["tweet_id"], name: "index_tweets_on_tweet_id", unique: true
  end

  create_table "twitter_users", force: :cascade do |t|
    t.string "name"
    t.integer "twitter_user_id", precision: 38
    t.string "screen_name"
    t.string "location"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "sign_in_count", precision: 38, default: 0, null: false
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.integer "confirm_count", precision: 38, default: 0
    t.integer "tweet_count", precision: 38, default: 0
    t.integer "pending_count", precision: 38, default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "i_users_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
