class Comment < ActiveRecord::Base

  acts_as_textiled :content

  belongs_to :target, :polymorphic=>true
  belongs_to :user

  validates_presence_of :content, :target

  attr_protected :user_id

end
