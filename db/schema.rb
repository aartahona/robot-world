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

ActiveRecord::Schema.define(version: 2020_11_12_135536) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "car_models", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.decimal "price"
    t.decimal "cost_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "stock"
  end

  create_table "cars", force: :cascade do |t|
    t.string "status"
    t.boolean "completed"
    t.bigint "car_model_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["car_model_id"], name: "index_cars_on_car_model_id"
  end

  create_table "factories", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["car_id"], name: "index_factories_on_car_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name"
    t.boolean "defective"
    t.bigint "car_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["car_id"], name: "index_parts_on_car_id"
  end

  add_foreign_key "cars", "car_models"
  add_foreign_key "factories", "cars"
  add_foreign_key "parts", "cars"
end