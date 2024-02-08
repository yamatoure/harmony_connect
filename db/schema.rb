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

ActiveRecord::Schema[7.0].define(version: 2024_02_08_151901) do
  create_table "areas", charset: "utf8", force: :cascade do |t|
    t.string "area", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_areas", charset: "utf8", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_group_areas_on_area_id"
    t.index ["group_id"], name: "index_group_areas_on_group_id"
  end

  create_table "group_parts", charset: "utf8", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_parts_on_group_id"
    t.index ["part_id"], name: "index_group_parts_on_part_id"
  end

  create_table "groups", charset: "utf8", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "member_areas", charset: "utf8", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_member_areas_on_area_id"
    t.index ["member_id"], name: "index_member_areas_on_member_id"
  end

  create_table "member_parts", charset: "utf8", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_parts_on_member_id"
    t.index ["part_id"], name: "index_member_parts_on_part_id"
  end

  create_table "members", charset: "utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "parts", charset: "utf8", force: :cascade do |t|
    t.string "part", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "group_areas", "areas"
  add_foreign_key "group_areas", "groups"
  add_foreign_key "group_parts", "groups"
  add_foreign_key "group_parts", "parts"
  add_foreign_key "groups", "users"
  add_foreign_key "member_areas", "areas"
  add_foreign_key "member_areas", "members"
  add_foreign_key "member_parts", "members"
  add_foreign_key "member_parts", "parts"
  add_foreign_key "members", "users"
end
