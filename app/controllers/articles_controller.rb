class ArticlesController < ApplicationController

  before_filter :login_required, :except => [ :show, :index ]

  def index
    begin # we first try with dates
      date = Date.new(params[:year].to_i,params[:month].to_i).to_time.beginning_of_month
      @articles = Article.find(:all,:conditions => {:published_at => date..date+1.month})
    rescue # if no date given, find the last 10 ones
      @articles = admin? ? Article.find(:all, :limit => 10) : Article.published.find(:all, :limit => 10)
    end
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def show
    @article = admin? ? Article.find(params[:id]) : Article.published.find(params[:id])
    @comment = Comment.new
    @page_title = @article.title
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user
    if @article.save
      flash[:ok] = 'Article créé.'
      redirect_to article_url(@article)
    else
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:ok] = 'Article mis à jour.'
      redirect_to article_url(@article)
    else
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_url
  end

  protected

  def authorized?
    admin?
  end

end