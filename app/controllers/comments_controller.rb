class CommentsController < ApplicationController

  before_filter :login_required

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:ok] = 'Commentaire sauvegardé.'
      UserMailer.deliver_admin_notice_newcomment(@comment) rescue nil # TODO move that to a MonitoringObserver
      redirect_to url_for(@article)
    else
      flash[:error] = 'Commentaire non sauvegardé.'
      redirect_to url_for(@article)
    end
  end

end