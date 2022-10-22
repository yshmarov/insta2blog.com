# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_22_174340) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "insta_access_tokens", force: :cascade do |t|
    t.string "access_token"
    t.integer "expires_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "insta_user_id"
  end

  create_table "insta_posts", force: :cascade do |t|
    t.bigint "remote_id"
    t.text "caption"
    t.string "media_type"
    t.text "media_url"
    t.text "permalink"
    t.text "thumbnail_url"
    t.datetime "timestamp"
    t.bigint "insta_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insta_user_id"], name: "index_insta_posts_on_insta_user_id"
    t.index ["remote_id"], name: "index_insta_posts_on_remote_id", unique: true
  end

  create_table "insta_users", force: :cascade do |t|
    t.bigint "remote_id"
    t.string "username"
    t.string "account_type"
    t.integer "media_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["remote_id"], name: "index_insta_users_on_remote_id", unique: true
    t.index ["slug"], name: "index_insta_users_on_slug", unique: true
    t.index ["username"], name: "index_insta_users_on_username", unique: true
  end

  add_foreign_key "insta_posts", "insta_users"
end
