class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, only: [:new, :create]
  before_action :author?, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def show
  end

  def edit

  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "\"#{@article.title}\" was successfully created!"
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = "\"#{@article.title}\" was successfully updated!"
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:danger] = "\"#{@article.title}\" was successfully deleted!"
    redirect_to articles_path
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def author?
    if current_user != @article.user
      flash[:danger] = "Sorry, you don't have privilege to do that"
      redirect_to articles_path
    end
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end
end
