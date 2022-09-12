class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find params[:id]
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params

    if @article.save
      redirect_to articles_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find params[:id]
  end

  def update
    @article = Article.find params[:id]
    @article.assign_attributes article_params

    if @article.save
      redirect_to articles_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find params[:id]

    @article.destroy!

    redirect_to articles_url
  end

  private

  def article_params
    params.require(:article).permit(:body)
  end
end
