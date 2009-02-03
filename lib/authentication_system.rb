module AuthenticationSystem

  protected

  def update_last_seen_at
    return unless logged_in?
    User.update_all ['last_seen_at = ?', Time.now.utc], ['id = ?', current_user.id] 
    current_user.last_seen_at = Time.now.utc
  end

  def login_required
    login_by_token      unless logged_in?
    login_by_basic_auth unless logged_in?
    respond_to do |format| 
      format.html { redirect_to login_path }
      format.js   { render(:update) { |p| p.redirect_to login_path } }
    end unless logged_in? && authorized?
  end

  def login_by_token
    self.current_user = User.find_by_id_and_login_key(*cookies[:login_token].split(";")) if cookies[:login_token] and not logged_in?
  end

  @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
  def login_by_basic_auth
    auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
    auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
    self.current_user = User.authenticate *Base64.decode64(auth_data[1]).split(':')[0..1] if auth_data && auth_data[0] == 'Basic'
  end

  def authorized?() true end

  def current_user=(value)
    if @current_user = value
      session[:user_id] = @current_user.id 
      # this is used while we're logged in to know which threads are new, etc
      session[:last_active] = @current_user.last_seen_at
      update_last_seen_at
    end
  end

  def current_user
    @current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
  end

  def logged_in?
    current_user != 0
  end

  def admin?
    logged_in? && current_user.admin?
  end

end