class UsersController < ApplicationController

  before_filter :login_required, :only => [:edit, :update, :destroy]
  before_filter :find_user,      :only => [:edit, :update, :destroy]

  def index
    conditions = params[:initial].blank? ? [] : ["lastname LIKE ?", "#{params[:initial].first}%"]
    @users = User.paginate :page => params[:page], :per_page => 10, :order => "lastname", :conditions => conditions
    @user_count = User.count
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new :country => "FR"
  end

  def create
    @user = params[:user].blank? ? User.find_by_email(params[:email]) : User.new(params[:user].except(:login))
    flash[:error] = "Aucun compte n'a été trouvé lié à l'adresse '#{params[:email]}'. Etes-vous certain de cette adresse?" if params[:email] and not @user
    redirect_to login_path and return unless @user
    @user.login = params[:user][:login] unless params[:user].blank?
    @user.reset_login_key
    @user.save! unless @user.valid? # kinda backwards, but trigger an ActiveRecord::RecordInvalid error if its not valid before attempting to send email
    flash[:ok] = params[:email] ? "Une clef de login temporaire vous a été envoyée à '#{@user.email}'." : "Merci. Une clef d'activation vous a été envoyée par email à '#{@user.email}'."
    # TODO The following is based on an old version of RESTful auth => switch to a more recent version (or maybe AuthLogic) because this is ugly
    begin
      UserMailer.deliver_signup(@user)
    rescue Net::SMTPFatalError => e
      flash[:error] = "A permanent error occured while sending the signup message to '#{@user.email}'. Please check the e-mail address."
      render :action => "new"
    rescue Net::SMTPServerBusy, Net::SMTPUnknownError, Net::SMTPSyntaxError, TimeoutError => e
      flash[:error] = "The signup message cannot be sent to '#{@user.email}' at this moment. Please, try again later."
      render :action => "new"
    else
      @user.save(false)
      flash[:ok] = params[:email] ? "Une clef de login temporaire vous a été envoyée à '#{@user.email}'." : "Merci. Une clef d'activation vous a été envoyée par email à '#{@user.email}'."
      redirect_to CGI.unescape(login_path)
    end
  end

  def activate
    self.current_user = User.find_by_login_key(params[:key])
    if logged_in? && !current_user.activated?
      current_user.toggle! :activated
      flash[:ok] = "Inscription terminée! Vous êtes a présent authentifié."
      UserMailer.deliver_admin_notice_newuser(current_user) rescue nil # TODO move that to a MonitoringObserver
    end
    redirect_to CGI.unescape(params[:to] || root_path)
  end

  def edit
  end

  def update
    @user.attributes = params[:user]
    @user.save! and flash[:ok]="OK."
    redirect_to user_path(@user)
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  protected

  def authorized?
    admin? || (!%w(destroy admin).include?(action_name) && (params[:id].nil? || params[:id] == current_user.to_param))
  end

  def find_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

end