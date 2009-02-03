# we don't want rails formatting for errors (we use our own)
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag }

# This is to strip accents and other extended chars from a string (used with slugs in URLs); not perfect
class String
  def remove_diacritics
    self.mb_chars.downcase.strip.normalize(:kd).split(//u).reject { |e| e.length > 2 }.join
  end
end