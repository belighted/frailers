class Membership < ActiveRecord::Base

  belongs_to :company
  belongs_to :user

  validates_uniqueness_of :user_id, :scope=>:company_id

  def can_be_created_by?(thisuser)
    (thisuser == company.owner)
  end

  def can_by_destroyed_by?(thisuser)
    (thisuser == company.owner) or (thisuser == user)
  end

end