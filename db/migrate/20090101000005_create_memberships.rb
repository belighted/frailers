class CreateMemberships < ActiveRecord::Migration

  def self.up
    create_table "memberships" do |t|
      t.integer  "user_id"
      t.integer  "company_id"
      t.integer  "status"
      t.datetime "authorized_at"
      t.datetime "accepted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "memberships", "user_id"
    add_index "memberships", "company_id"
  end

  def self.down
    drop_table "memberships"
  end

end