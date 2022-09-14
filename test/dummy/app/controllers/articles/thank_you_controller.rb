class Articles::ThankYouController < PrefixedController
  def show
    @article = Article.find params[:article_id]
  end
end
