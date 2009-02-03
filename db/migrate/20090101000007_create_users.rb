class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table "users" do |t|
      t.string   "login"
      t.string   "email"
      t.string   "firstname"
      t.string   "lastname"
      t.string   "display_name"
      t.integer  "image_id"
      t.string   "website"
      t.text     "description"
      t.date     "railer_since"
      t.string   "company_name"
      t.string   "company_url"
      t.integer  "company_id"
      t.string   "country"
      t.string   "city"
      t.string   "password_hash"
      t.string   "login_key"
      t.boolean  "admin",                :default => false
      t.boolean  "activated",            :default => false
      t.datetime "last_login_at"
      t.datetime "last_seen_at"
      t.datetime "login_key_expires_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "picture_file_name"
      t.string   "picture_content_type"
      t.integer  "picture_file_size"
      t.datetime "picture_updated_at"
    end
    add_index "users", "lastname"
  end

  def self.down
    drop_table "users"
  end

end