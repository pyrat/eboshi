# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080922214952) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "email"
    t.string   "contact"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "client_id"
    t.datetime "date"
    t.datetime "paid"
    t.string   "project_name"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "start"
    t.datetime "finish"
    t.decimal  "rate",       :precision => 10, :scale => 2
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invoice_id"
    t.string   "type"
  end

  create_table "todos", :force => true do |t|
    t.integer  "client_id",  :limit => 8
    t.integer  "user_id",    :limit => 8
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.decimal  "rate",                                    :precision => 10, :scale => 2
  end

end
