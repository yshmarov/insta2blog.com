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

ActiveRecord::Schema[7.1].define(version: 2023_10_15_113917) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "insta_access_tokens", force: :cascade do |t|
    t.string "access_token"
    t.integer "expires_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "insta_user_id"
    t.datetime "expires_at", null: false
  end

  create_table "insta_carousel_items", force: :cascade do |t|
    t.bigint "remote_id"
    t.string "media_type"
    t.string "media_url"
    t.text "permalink"
    t.text "thumbnail_url"
    t.datetime "timestamp"
    t.bigint "insta_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insta_post_id"], name: "index_insta_carousel_items_on_insta_post_id"
    t.index ["remote_id"], name: "index_insta_carousel_items_on_remote_id", unique: true
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
    t.text "processed_caption"
    t.integer "insta_carousel_items_count", default: 0, null: false
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
    t.integer "insta_posts_count", default: 0, null: false
    t.datetime "last_import_at"
    t.bigint "user_id"
    t.datetime "last_profile_import_at"
    t.index ["remote_id"], name: "index_insta_users_on_remote_id", unique: true
    t.index ["slug"], name: "index_insta_users_on_slug", unique: true
    t.index ["user_id"], name: "index_insta_users_on_user_id"
    t.index ["username"], name: "index_insta_users_on_username", unique: true
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.string "authenticatable_type"
    t.bigint "authenticatable_id"
    t.datetime "timeout_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "claimed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "token_digest"
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
    t.index ["token_digest"], name: "index_passwordless_sessions_on_token_digest"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "insta_carousel_items", "insta_posts"
  add_foreign_key "insta_posts", "insta_users"
  add_foreign_key "insta_users", "users"
end
