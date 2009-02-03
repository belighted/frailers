class EventsController < ApplicationController

  before_filter :login_required, :except => [ :show, :index ]

  def index
    @events = Event.find(:all)
    @event_count = Event.count
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new params[:event]
    @event.creator=current_user
    @event.save! and flash[:ok] = "Evénement créé."
    redirect_to event_path(@event)
  end

  def update
    @event = Event.find(params[:id])
    @event.attributes = params[:event]
    @event.save! and flash[:ok] = "Evénement mis à jour."
    redirect_to event_path(@event)
  end

  def destroy
    @event.destroy(params[:id])
    redirect_to events_url
  end

  protected

  def authorized?
    admin?
  end

end