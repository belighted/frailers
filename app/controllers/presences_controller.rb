class PresencesController < ApplicationController

  before_filter :find_user

  def create
    @event = Event.find(params[:event_id])
    @presence = @event.presences.build :user=>@user
    if @presence.can_be_created_by?(current_user) and @presence.save
      flash[:ok] = "Votre participation à #{@event.name} a été enregistrée."
    else
      flash[:error] = "Désolé, vous n'avez pas les droits nécessaires."
    end
    redirect_to event_url(@event)
  end

  def destroy
    @event = Event.find(params[:event_id])
    @presence = @event.presences.find(params[:id])
    if @presence.can_by_destroyed_by?(current_user) and @presence.destroy
      flash[:ok] = "Votre participation à #{@event.name} a été supprimée."
    else
      flash[:error] = "Désolé, vous n'avez pas les droits nécessaires."
    end
    redirect_to event_url(@event)
  end

  private

  def find_user
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
  end

end