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

ActiveRecord::Schema.define(version: 20180109174010) do

  create_table "answers", force: :cascade do |t|
    t.text "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statement_id"
    t.index ["statement_id"], name: "index_answers_on_statement_id"
  end

  create_table "choices", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statement_id"
    t.index ["statement_id"], name: "index_choices_on_statement_id"
  end

  create_table "roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statements", force: :cascade do |t|
    t.text "style"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
    t.index ["topic_id"], name: "index_statements_on_topic_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_topics_on_role_id"
    t.index ["survey_id"], name: "index_topics_on_survey_id"
  end

end
