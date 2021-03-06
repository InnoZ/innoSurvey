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

ActiveRecord::Schema.define(version: 20180302125657) do

  create_table "answers", force: :cascade do |t|
    t.text "selected_choices", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statement_id"
    t.string "uuid", null: false
    t.index ["statement_id"], name: "index_answers_on_statement_id"
  end

  create_table "choices", force: :cascade do |t|
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statement_id"
    t.index ["statement_id"], name: "index_choices_on_statement_id"
  end

  create_table "roles", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_id"
    t.index ["survey_id"], name: "index_roles_on_survey_id"
  end

  create_table "statement_sets", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_statement_sets_on_role_id"
    t.index ["topic_id"], name: "index_statement_sets_on_topic_id"
  end

  create_table "statements", force: :cascade do |t|
    t.text "style", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statement_set_id"
    t.index ["statement_set_id"], name: "index_statements_on_statement_set_id"
  end

  create_table "stations", force: :cascade do |t|
    t.integer "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["survey_id"], name: "index_stations_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "name", null: false
    t.string "name_url_safe", null: false
    t.index ["user_id"], name: "index_surveys_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "station_id"
    t.string "name", null: false
    t.index ["station_id"], name: "index_topics_on_station_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
