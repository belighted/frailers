class Event < ActiveRecord::Base

  has_attached_file :picture, :styles => { :thumb75 => "75x75#", :thumb25 => "25x25#" },
                    :url  => "/uploads/events/:id/picture/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/events/:id/picture/:style/:basename.:extension",
                    :default_url => "/images/default_event_picture_:style.jpg"

  belongs_to :creator, :class_name => "User"
  has_many :presences, :dependent => :destroy
  has_many :users, :through=>:presences

  default_scope :order => "begins_at desc"

  validates_presence_of :name, :country, :website, :begins_at, :ends_at, :creator

  def to_s
    name
  end

  def to_param
    "#{id}-#{self.name.remove_diacritics.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '')}"
  end

end