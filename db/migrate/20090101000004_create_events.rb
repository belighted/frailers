class CreateEvents < ActiveRecord::Migration

  def self.up
    create_table "events" do |t|
      t.string   "name"
      t.string   "venue"
      t.string   "street"
      t.string   "street_number"
      t.string   "postal_code"
      t.string   "city"
      t.string   "website"
      t.text     "description"
      t.string   "country"
      t.integer  "image_id"
      t.datetime "begins_at"
      t.datetime "ends_at"
      t.integer  "creator_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "picture_file_name"
      t.string   "picture_content_type"
      t.integer  "picture_file_size"
      t.datetime "picture_updated_at"
    end
    add_index "events", "begins_at"
  end

  def self.down
    drop_table "events"
  end

end