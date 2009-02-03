class Presence < ActiveRecord::Base

  belongs_to :event
  belongs_to :user

  validates_uniqueness_of :user_id, :scope=>:event_id

  def can_be_created_by?(thisuser)
    (thisuser == event.creator) or (thisuser == user)
  end

  def can_by_destroyed_by?(thisuser)
    (thisuser == event.creator) or (thisuser == user)
  end

end