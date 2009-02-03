class SessionsController < ApplicationController

  def create
    if self.current_user = User.authenticate(params[:login], params[:password])
      cookies[:login_token] = {:value => "#{current_user.id};#{current_user.reset_login_key!}", :expires => 1.year.from_now.utc} if params[:remember_me] == "1"
      redirect_to CGI.unescape(params[:to] || root_path)
    else
      flash.now[:error] = "Login ou mot de passe invalide, veuillez réessayer."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete :login_token
    flash[:notice] = "Vous êtes à présent déloggé."
    redirect_to root_path
  end

end