class CompaniesController < ApplicationController

  before_filter :login_required, :except => [ :index, :show ]

  def index
    conditions = params[:initial].blank? ? [] : ["name LIKE ?", "#{params[:initial].first}%"]
    @companies = Company.paginate(:page => params[:page], :per_page => 10, :order => "name", :conditions=>conditions)
    @company_count = Company.count
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new(:country=>current_user.country)
  end

  def create
    @company=current_user.companies.build params[:company]
    @company.owner = current_user
    @company.valid?
    puts @company.errors.inspect
    @company.save! and flash[:ok] = "Société enregistrée."
    redirect_to @company
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    @company.attributes = params[:company]
    @company.save! and flash[:ok] = "Société mise à jour."
    redirect_to @company
  end

  def destroy
    @company.destroy(params[:id])
    redirect_to companies_path
  end

  protected

  def authorized?
    admin? || %w(create new).include?(action_name) || (!%w(destroy update).include?(action_name) && (current_user == @company.owner))
  end

end