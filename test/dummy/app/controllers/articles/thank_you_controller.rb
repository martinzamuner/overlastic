class Articles::ThankYouController < ApplicationController
  def show
    @article = Article.find params[:article_id]
  end
end
