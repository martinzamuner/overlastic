class CommentsController < PrefixedController
  def show
    @comment = article.comments.find params[:id]
  end

  def new
    @comment = article.comments.build
  end

  def create
    @comment = article.comments.build comment_params

    if @comment.save
      redirect_to [controller_prefix, article], overlay: :previous, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @comment = article.comments.find params[:id]
  end

  def update
    @comment = article.comments.find params[:id]
    @comment.assign_attributes comment_params

    if @comment.save
      redirect_to [controller_prefix, article], overlay: :previous, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = article.comments.find params[:id]

    @comment.destroy!

    if request.variant.overlay?
      close_overlay
    else
      redirect_to [controller_prefix, :articles], status: :see_other
    end
  end

  private

  def article
    @article ||= Article.find params[:article_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
