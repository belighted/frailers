class CreateArticles < ActiveRecord::Migration

  def self.up
    create_table "articles" do |t|
      t.string   "title"
      t.text     "summary"
      t.text     "content"
      t.integer  "author_id"
      t.datetime "published_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "articles", "published_at"
  end

  def self.down
    drop_table "articles"
  end

end