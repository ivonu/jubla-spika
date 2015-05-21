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

ActiveRecord::Schema.define(version: 20150521045704) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "entry_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "attachments", ["entry_id"], name: "index_attachments_on_entry_id"

  create_table "comments", force: :cascade do |t|
    t.text     "text"
    t.integer  "entry_id"
    t.integer  "program_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["entry_id"], name: "index_comments_on_entry_id"
  add_index "comments", ["program_id"], name: "index_comments_on_program_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "entries", force: :cascade do |t|
    t.string   "title"
    t.string   "title_other"
    t.text     "description"
    t.text     "material"
    t.text     "remarks"
    t.text     "preparation"
    t.text     "keywords"
    t.boolean  "part_start"
    t.boolean  "part_main"
    t.boolean  "part_end"
    t.boolean  "indoors"
    t.boolean  "outdoors"
    t.boolean  "weather_snow"
    t.boolean  "weather_rain"
    t.boolean  "weather_sun"
    t.boolean  "act_active"
    t.boolean  "act_calm"
    t.boolean  "act_creative"
    t.integer  "group_size_min"
    t.integer  "group_size_max"
    t.integer  "age_min"
    t.integer  "age_max"
    t.integer  "time_min"
    t.integer  "time_max"
    t.boolean  "independent"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "rating"
    t.integer  "user_id"
    t.boolean  "published"
    t.integer  "edited_entry"
    t.boolean  "cat_pocket"
    t.boolean  "cat_craft"
    t.boolean  "cat_cook"
    t.boolean  "cat_pioneer"
    t.boolean  "cat_night"
  end

  add_index "entries", ["user_id"], name: "index_entries_on_user_id"

  create_table "links", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "program_entries", force: :cascade do |t|
    t.integer  "entry_id"
    t.integer  "program_id"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "program_entries", ["entry_id"], name: "index_program_entries_on_entry_id"
  add_index "program_entries", ["program_id"], name: "index_program_entries_on_program_id"

  create_table "programs", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "rating"
    t.integer  "user_id"
  end

  add_index "programs", ["user_id"], name: "index_programs_on_user_id"

  create_table "ratings", force: :cascade do |t|
    t.integer  "value"
    t.integer  "entry_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "program_id"
  end

  add_index "ratings", ["entry_id"], name: "index_ratings_on_entry_id"
  add_index "ratings", ["program_id"], name: "index_ratings_on_program_id"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
