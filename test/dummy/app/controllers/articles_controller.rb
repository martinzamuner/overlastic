class ArticlesController < PrefixedController
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
      redirect_to [controller_prefix, @article, :thank_you], notice: "Created!", status: :see_other
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
      redirect_to [controller_prefix, :articles], notice: "Updated!", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find params[:id]

    @article.destroy!

    if request.variant.overlay?
      close_overlay notice: "Deleted!"
    else
      redirect_to [controller_prefix, :articles], status: :see_other
    end
  end

  private

  def article_params
    params.require(:article).permit(:body)
  end
end
