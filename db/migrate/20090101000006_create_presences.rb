class CreatePresences < ActiveRecord::Migration

  def self.up
    create_table "presences" do |t|
      t.integer  "user_id"
      t.integer  "event_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "presences", "event_id"
  end

  def self.down
    drop_table "presences"
  end

end