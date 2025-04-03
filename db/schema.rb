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

ActiveRecord::Schema[7.1].define(version: 2025_04_03_195128) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pledges", force: :cascade do |t|
    t.bigint "backer_id", null: false
    t.bigint "project_id", null: false
    t.bigint "reward_id"
    t.decimal "amount", precision: 10, scale: 2
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["backer_id"], name: "index_pledges_on_backer_id"
    t.index ["project_id"], name: "index_pledges_on_project_id"
    t.index ["reward_id"], name: "index_pledges_on_reward_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "goal", precision: 10, scale: 2
    t.datetime "end_date"
    t.bigint "creator_id", null: false
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.string "category"
    t.index ["creator_id"], name: "index_projects_on_creator_id"
  end

  create_table "reward_items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "quantity_per_reward", default: 1, null: false
    t.integer "total_needed", default: 0, null: false
    t.integer "produced_count", default: 0, null: false
    t.integer "shipped_count", default: 0, null: false
    t.bigint "reward_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id", "name"], name: "index_reward_items_on_reward_id_and_name", unique: true
    t.index ["reward_id"], name: "index_reward_items_on_reward_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "title"
    t.text "description"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "quantity"
    t.integer "claimed_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "estimated_delivery"
    t.string "status", default: "not_started"
    t.integer "fulfillment_progress", default: 0
    t.date "estimated_shipping_date"
    t.index ["project_id"], name: "index_rewards_on_project_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "title"
    t.text "description"
    t.string "status", default: "draft"
    t.datetime "sent_at"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_surveys_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "type"
    t.string "roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "pledges", "projects"
  add_foreign_key "pledges", "rewards"
  add_foreign_key "pledges", "users", column: "backer_id"
  add_foreign_key "projects", "users", column: "creator_id"
  add_foreign_key "reward_items", "rewards"
  add_foreign_key "rewards", "projects"
  add_foreign_key "surveys", "projects"
end
