class CreateComments < ActiveRecord::Migration

  def self.up
    create_table "comments" do |t|
      t.string   "name"
      t.string   "mail"
      t.string   "website"
      t.text     "content"
      t.integer  "target_id"
      t.string   "target_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
    end 
    add_index "comments", "target_id"
    add_index "comments", "created_at"
  end

  def self.down
    drop_table "comments"
  end

end