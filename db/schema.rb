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

ActiveRecord::Schema[7.2].define(version: 2026_01_30_125130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_answer_logs_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "answer_log_id", null: false
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.bigint "option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_log_id"], name: "index_answers_on_answer_log_id"
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "coordinate_options", force: :cascade do |t|
    t.bigint "coordinate_id", null: false
    t.bigint "option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinate_id", "option_id"], name: "index_coordinate_options_on_coordinate_id_and_option_id", unique: true
    t.index ["coordinate_id"], name: "index_coordinate_options_on_coordinate_id"
    t.index ["option_id"], name: "index_coordinate_options_on_option_id"
  end

  create_table "coordinates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "name"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answer_logs", "users"
  add_foreign_key "answers", "answer_logs"
  add_foreign_key "answers", "options"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "coordinate_options", "coordinates"
  add_foreign_key "coordinate_options", "options"
  add_foreign_key "options", "questions"
end
