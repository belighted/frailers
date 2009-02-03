class UserMailer < ActionMailer::Base

  def signup(user)
    setup_email(user)
    @subject    += 'Veuillez activer votre nouveau compte'
  end

  def admin_notice_newuser(user)
    setup_admin_email
    @body[:user] = user
    @subject += 'users++'
  end

  def admin_notice_newcomment(comment)
    setup_admin_email
    @body[:comment] = comment
    @subject += 'comments++'
  end

  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "noreply@frailers.net"
    @subject     = "[Frailers] "
    @sent_on     = Time.now
    @body[:user] = user
    @body[:url]  = "http://www.frailers.net"
  end

  def setup_admin_email
    @recipients  = "Les gars cool de chez Frailers <frailers@frailers.net>"
    @from        = "noreply@frailers.net"
    @subject     = "[Frailers] [Notice] "
    @sent_on     = Time.now
    @body[:url]  = "http://www.frailers.net"
  end

end