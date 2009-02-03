class MembershipsController < ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @users = @company.members.paginate :page => params[:page], :per_page => 10, :order => "display_name", :conditions => User.build_search_conditions(params[:q])
  end

  def create
    @company = Company.find(params[:company_id])
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @membership = @company.memberships.build :user=>@user
    if @membership.can_be_created_by?(current_user) and @membership.save
      flash[:ok] = "Vous êtes maintenant inscrit à #{@company.name}."
    else
      flash[:error] = "Désolé, vous n'avez pas les droits nécessaires."
    end
    redirect_to @company
  end

  def destroy
    @company = Company.find(params[:company_id])
    @membership = @company.memberships.find(params[:id])
    if @membership.can_by_destroyed_by?(current_user) and @membership.destroy
      flash[:ok] = "Vous êtes maintenant désinscrit de #{@company.name}."
    else
      flash[:error] = "Désolé, vous n'avez pas les droits nécessaires."
    end
    redirect_to @company
  end

end