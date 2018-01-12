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

ActiveRecord::Schema.define(version: 20160905133029) do

  create_table "manufacturers", force: :cascade do |t|
    t.string   "m_name"
    t.text     "m_full_name"
    t.text     "m_description"
    t.text     "m_address"
    t.text     "m_email"
    t.text     "m_website"
    t.text     "m_note"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "logo"
  end

  create_table "packages", force: :cascade do |t|
    t.string   "pk_number"
    t.string   "pk_name"
    t.text     "pk_description"
    t.text     "pk_note"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "pk_photo"
  end
end
