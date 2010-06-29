require 'digest/sha1'

class User < ActiveRecord::Base

  has_attached_file :picture, :styles => { :thumb75 => "75x75#", :thumb25 => "25x25#" },
                    :url  => "/uploads/users/:id/picture/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/users/:id/picture/:style/:basename.:extension",
                    :default_url => "/images/default_user_picture_:style.jpg"

  has_many    :memberships, :dependent => :destroy
  has_many    :companies,   :through => :memberships
  has_many    :presences
  has_many    :events,      :through => :presences
  has_many    :articles,    :as => :author

  validates_presence_of     :login, :email, :firstname, :lastname
  validates_length_of       :login, :minimum => 2
  validates_presence_of     :password_hash
  validates_length_of       :password, :minimum => 5, :allow_nil => true
  validates_confirmation_of :password, :on => :create
  validates_confirmation_of :password, :on => :update, :allow_nil => true
  validates_format_of       :login, :with => /^[a-z]{2}(?:\w+)?$/i # names that start with #s really upset me for some reason
  validates_format_of       :display_name, :with => /^[a-z]{2}(?:[.'\-\w ]+)?$/i, :allow_nil => true # names that start with #s really upset me for some reason
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_uniqueness_of   :email, :case_sensitive => false, :allow_nil => true

  before_validation { |u| u.display_name = u.login if u.display_name.blank? }
  before_create     { |u| u.admin = u.activated = true if User.count == 0 } # first user becomes admin automatically

  attr_reader :password
  attr_protected :admin, :login, :created_at, :updated_at, :last_login_at,:activated
  
  PASSWORD_SALT = Frailers::CONFIG["password_salt"] # put the secret value of your choice in that file

  def self.authenticate(login, password, activated=true)
    find_by_login_and_password_hash_and_activated(login, Digest::SHA1.hexdigest("#{password}#{PASSWORD_SALT}"), activated)
  end

  def self.search(query, options = {})
    with_scope :find => { :conditions => build_search_conditions(query) } do
      find :all, options
    end
  end

  def self.build_search_conditions(query)
    query && ['LOWER(display_name) LIKE :q OR LOWER(login) LIKE :q', {:q => "%#{query}%"}]
  end

  def to_s
    display_name || login
  end

  def real_name
    "#{firstname} #{lastname}" unless firstname.blank? or lastname.blank?
  end

  def password=(value)
    return if value.blank?
    write_attribute :password_hash, Digest::SHA1.hexdigest(value + PASSWORD_SALT)
    @password = value
  end

  def reset_login_key
    self.login_key_expires_at = Time.now.utc+1.year
    self.login_key = Digest::SHA1.hexdigest(Time.now.to_s + password_hash.to_s + rand(123456789).to_s).to_s
  end

  def reset_login_key!
    reset_login_key
    save!
    login_key
  end

  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :email << :login_key << :login_key_expires_at << :password_hash
    super
  end

  def to_param
    "#{id}-#{self.login.remove_diacritics.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '')}"
  end

end