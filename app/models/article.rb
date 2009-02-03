class Article < ActiveRecord::Base

  acts_as_textiled :content, :summary
  named_scope      :published, :conditions => ["published_at IS NOT NULL"]
  default_scope    :order => "- published_at ASC"

  has_many   :comments, :as=>:target
  belongs_to :author, :class_name=>'User', :foreign_key=>'author_id'

  before_save :erase_published_at_if_not_published

  def published=(value)
    @published=true if value == "1"
  end

  def published
    !published_at.nil?
  end

  alias :published? :published

  def erase_published_at_if_not_published
    self.published_at = nil unless @published
  end

  def to_param
    "#{id}-#{self.title.remove_diacritics.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '')}"
  end

end