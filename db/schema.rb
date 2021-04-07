# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_07_162805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "circle_accountabilities", force: :cascade do |t|
    t.bigint "circle_id", null: false
    t.text "content"
    t.index ["circle_id"], name: "index_circle_accountabilities_on_circle_id"
  end

  create_table "circles", force: :cascade do |t|
    t.string "title"
    t.string "acronym"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "super_circle_id"
    t.text "purpose"
    t.index ["super_circle_id"], name: "index_circles_on_super_circle_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "nickname"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "role_fillings", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.index ["employee_id"], name: "index_role_fillings_on_employee_id"
    t.index ["role_id"], name: "index_role_fillings_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role_type"
    t.bigint "primary_circle_id"
    t.bigint "secondary_circle_id"
    t.string "acronym"
    t.index ["primary_circle_id"], name: "index_roles_on_primary_circle_id"
    t.index ["secondary_circle_id"], name: "index_roles_on_secondary_circle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "circle_accountabilities", "circles"
  add_foreign_key "circles", "circles", column: "super_circle_id"
  add_foreign_key "employees", "users"
  add_foreign_key "role_fillings", "employees"
  add_foreign_key "role_fillings", "roles"
  add_foreign_key "roles", "circles", column: "primary_circle_id"
  add_foreign_key "roles", "circles", column: "secondary_circle_id"
end
