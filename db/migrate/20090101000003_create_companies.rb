class CreateCompanies < ActiveRecord::Migration

  def self.up
    create_table "companies" do |t|
      t.string   "name"
      t.string   "keyname"
      t.string   "website"
      t.text     "description"
      t.string   "country"
      t.string   "city"
      t.integer  "image_id"
      t.integer  "owner_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "picture_file_name"
      t.string   "picture_content_type"
      t.integer  "picture_file_size"
      t.datetime "picture_updated_at"
    end
    add_index "companies", "name"
  end

  def self.down
    drop_table "companies"
  end

end