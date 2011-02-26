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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110226061357) do

  create_table "data_forms", :force => true do |t|
    t.string   "comment"
    t.integer  "s_type"
    t.integer  "state",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_lists", :force => true do |t|
    t.integer  "data_form_id"
    t.integer  "firework_id"
    t.integer  "data_number"
    t.integer  "last_data"
    t.integer  "s_type"
    t.integer  "state",        :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "before_data"
  end

  create_table "fireworks", :force => true do |t|
    t.string   "name"
    t.integer  "spec"
    t.integer  "lastdata",                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment",    :limit => 60
  end

end