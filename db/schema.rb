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

ActiveRecord::Schema.define(version: 2019_10_21_073925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "activity_name", null: false
    t.bigint "category_id"
    t.datetime "from_time", null: false
    t.datetime "to_time", null: false
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender", limit: 1, default: "0"
    t.date "birth_date"
    t.integer "age", limit: 2
    t.string "user_icon"
    t.string "employment"
    t.string "hobby"
    t.string "remarks"
    t.string "age_birth_checkflg", limit: 1, default: "2", null: false
  end

end
