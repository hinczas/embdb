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

ActiveRecord::Schema.define(version: 20160905133029) do

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authors_books", ["author_id", "book_id"], name: "index_authors_books_on_author_id_and_book_id", unique: true
  add_index "authors_books", ["author_id"], name: "index_authors_books_on_author_id"
  add_index "authors_books", ["book_id"], name: "index_authors_books_on_book_id"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.integer  "series"
    t.string   "isbn"
    t.string   "language"
    t.text     "sunopsis"
    t.string   "cover"
    t.string   "cover_typ"
    t.integer  "year"
    t.text     "notes"
    t.integer  "author_id"
    t.integer  "publisher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id"
  add_index "books", ["publisher_id"], name: "index_books_on_publisher_id"
  add_index "books", ["user_id"], name: "index_books_on_user_id"

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "hash_name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "project_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "documents", ["project_id"], name: "index_documents_on_project_id"

  create_table "genres", force: :cascade do |t|
    t.text     "name"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_movies", id: false, force: :cascade do |t|
    t.integer  "genre_id"
    t.integer  "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "genres_movies", ["genre_id", "movie_id"], name: "index_genres_movies_on_genre_id_and_movie_id", unique: true
  add_index "genres_movies", ["genre_id"], name: "index_genres_movies_on_genre_id"
  add_index "genres_movies", ["movie_id"], name: "index_genres_movies_on_movie_id"

  create_table "locations", force: :cascade do |t|
    t.string   "l_name"
    t.text     "l_description"
    t.text     "l_note"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "l_photo"
  end

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

  create_table "mformats", force: :cascade do |t|
    t.string   "mformat"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mlanguages", force: :cascade do |t|
    t.string   "mlanguage"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string   "title"
    t.string   "sub_title"
    t.integer  "num_title"
    t.integer  "part"
    t.string   "imdb"
    t.text     "postgres"
    t.text     "sunopsis"
    t.date     "last_seen"
    t.integer  "watch_count"
    t.integer  "own"
    t.integer  "mtype_id"
    t.integer  "myear_id"
    t.integer  "mformat_id"
    t.integer  "quality_id"
    t.integer  "mlanguage_id"
    t.integer  "msubtitle_id"
    t.integer  "threed_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "director"
    t.text     "writer"
    t.text     "actor"
    t.text     "poster"
  end

  add_index "movies", ["mformat_id"], name: "index_movies_on_mformat_id"
  add_index "movies", ["mlanguage_id"], name: "index_movies_on_mlanguage_id"
  add_index "movies", ["msubtitle_id"], name: "index_movies_on_msubtitle_id"
  add_index "movies", ["mtype_id"], name: "index_movies_on_mtype_id"
  add_index "movies", ["myear_id"], name: "index_movies_on_myear_id"
  add_index "movies", ["quality_id"], name: "index_movies_on_quality_id"
  add_index "movies", ["threed_id"], name: "index_movies_on_threed_id"

  create_table "msubtitles", force: :cascade do |t|
    t.string   "msubtitle"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mtypes", force: :cascade do |t|
    t.string   "mtype"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "myears", force: :cascade do |t|
    t.integer  "myear"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "part_pcbs", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "pcb_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "part_pcbs", ["part_id"], name: "index_part_pcbs_on_part_id"
  add_index "part_pcbs", ["pcb_id"], name: "index_part_pcbs_on_pcb_id"

  create_table "part_projects", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "project_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "part_projects", ["part_id"], name: "index_part_projects_on_part_id"
  add_index "part_projects", ["project_id"], name: "index_part_projects_on_project_id"

  create_table "parts", force: :cascade do |t|
    t.string   "part_number"
    t.text     "part_name"
    t.string   "p_type"
    t.text     "p_description"
    t.text     "keywords"
    t.float    "voltage"
    t.float    "current"
    t.text     "p_note"
    t.integer  "p_quantity"
    t.integer  "p_pin_count"
    t.integer  "package_id"
    t.integer  "location_id"
    t.integer  "manufacturer_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "p_price"
    t.integer  "type_id"
    t.text     "file_1"
    t.text     "file_lbr"
  end

  add_index "parts", ["location_id"], name: "index_parts_on_location_id"
  add_index "parts", ["manufacturer_id"], name: "index_parts_on_manufacturer_id"
  add_index "parts", ["package_id"], name: "index_parts_on_package_id"
  add_index "parts", ["type_id"], name: "index_parts_on_type_id"

  create_table "parts_pcbs", id: false, force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "pcb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "parts_pcbs", ["part_id", "pcb_id"], name: "index_parts_pcbs_on_part_id_and_pcb_id", unique: true
  add_index "parts_pcbs", ["part_id"], name: "index_parts_pcbs_on_part_id"
  add_index "parts_pcbs", ["pcb_id"], name: "index_parts_pcbs_on_pcb_id"

  create_table "pcb_projects", force: :cascade do |t|
    t.integer  "pcb_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "quantity"
  end

  add_index "pcb_projects", ["pcb_id"], name: "index_pcb_projects_on_pcb_id"
  add_index "pcb_projects", ["project_id"], name: "index_pcb_projects_on_project_id"

  create_table "pcbs", force: :cascade do |t|
    t.string   "name"
    t.string   "version"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.float    "cost"
    t.text     "changelog"
    t.string   "sch_file"
    t.string   "brd_file"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "photo"
  end

  create_table "photos", force: :cascade do |t|
    t.string   "name"
    t.string   "hash_name"
    t.integer  "project_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "photos", ["project_id"], name: "index_photos_on_project_id"

  create_table "projects", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "version"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.text     "description"
    t.text     "log"
    t.string   "folder_location"
    t.string   "background"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "name"
    t.string   "full_name"
    t.text     "address"
    t.string   "website"
    t.string   "contact"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qualities", force: :cascade do |t|
    t.string   "quality"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "item_quantity"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "threeds", force: :cascade do |t|
    t.string   "threed"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.text     "t_description"
    t.text     "t_note"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "name"
    t.text     "middle_name"
    t.text     "surname"
    t.date     "birth_date"
    t.text     "address"
    t.string   "mobile"
    t.string   "email"
    t.string   "photo"
    t.string   "encrypted_password"
    t.string   "salt"
    t.text     "notes"
    t.string   "username"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "level"
  end

end
