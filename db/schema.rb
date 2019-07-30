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

ActiveRecord::Schema.define(version: 20190728115905) do

  create_table "approvals", force: :cascade do |t|
    t.integer "user_id"
    t.date "month"
    t.integer "superior_id"
    t.integer "status_id", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_approvals_on_user_id"
  end

  create_table "attendancelogs", force: :cascade do |t|
    t.date "attendance_date"
    t.datetime "first_started_at"
    t.datetime "first_finished_at"
    t.datetime "latest_started_at"
    t.datetime "latest_finished_at"
    t.integer "superior_id"
    t.date "approvaled_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendancelogs_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "first_started_at"
    t.datetime "first_finished_at"
    t.boolean "next_day", default: false, null: false
    t.string "note"
    t.integer "status_id", default: 1, null: false
    t.datetime "end_overtime"
    t.string "business_content"
    t.integer "superior_id_for_overtime"
    t.integer "status_id_overtime", default: 1, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "superior_id"
    t.datetime "applying_started_at"
    t.datetime "applying_finished_at"
    t.boolean "next_day_for_overtime", default: false, null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "centers", force: :cascade do |t|
    t.integer "number", null: false
    t.string "name", null: false
    t.string "attendance_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "overtimes", force: :cascade do |t|
    t.integer "user_id"
    t.date "applied_on"
    t.time "end_overtime"
    t.string "business_content"
    t.integer "superior_id"
    t.string "permit_note"
    t.integer "status_id", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_overtimes_on_user_id"
  end

  create_table "stamps", force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "superior_id"
    t.integer "status_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stamps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2019-07-29 23:00:00"
    t.datetime "work_time", default: "2019-07-29 22:30:00"
    t.boolean "superior", default: false
    t.integer "employee_number"
    t.string "uid"
    t.datetime "designated_work_start_time", default: "2019-07-30 00:00:00"
    t.datetime "designated_work_end_time", default: "2019-07-30 09:00:00"
    t.time "basic_work_time", default: "2000-01-01 23:00:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
