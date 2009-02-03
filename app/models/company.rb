class Company < ActiveRecord::Base

  has_attached_file :picture, :styles => { :thumb75 => "75x75#", :thumb25 => "25x25#" },
                    :url  => "/uploads/companies/:id/picture/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/companies/:id/picture/:style/:basename.:extension",
                    :default_url => "/images/default_company_picture_:style.jpg"

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
  has_many   :memberships, :dependent => :destroy
  has_many   :members, :through=>:memberships, :source=>:user

  validates_presence_of :name, :owner_id

  def to_s
    name
  end

  def self.build_search_conditions(query)
    query && ['LOWER(display_name) LIKE :q OR LOWER(login) LIKE :q', {:q => "%#{query}%"}]
  end

  def to_param
    "#{id}-#{self.name.remove_diacritics.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '')}"
  end

end