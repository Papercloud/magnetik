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

ActiveRecord::Schema.define(version: 20151008025835) do

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "stripe_customer_id"
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id"

  create_table "magnetik_credit_cards", force: :cascade do |t|
    t.string   "stripe_card_id",    null: false
    t.string   "last_4_digits",     null: false
    t.string   "exp_month",         null: false
    t.string   "exp_year",          null: false
    t.string   "brand",             null: false
    t.boolean  "is_default"
    t.integer  "customer_id",       null: false
    t.string   "customer_type",     null: false
    t.string   "name"
    t.datetime "last_validated_at", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "magnetik_credit_cards", ["customer_id", "customer_id"], name: "index_magnetik_credit_cards_on_customer_id_and_customer_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "stripe_customer_id"
  end

end
