class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authenticate_user!, except:[:index, :show]  
  before_action :verify_user, only:[:edit, :update, :destroy, :myarticles]

  # GET /articles
  def index
    @articles = Article.all

    render json: @articles, status: :ok
  end

  # GET /articles/1
  def show
    render json: @article, status: :ok
  end

  # GET /articles/myarticles
  def myarticles
    @articles = current_author.articles.all

    render json: @articles, status: :ok
  end

  # POST /articles
  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    render json: {message: "Deleted Successfully"},status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :topic, :text, :likes, :comments, :views, :user_id)
    end


    def verify_user
      @articles = current_user.articles.find_by(id: params[:id])
      render json: {message: "Not authorized to edit this article"},status: :unprocessable_entity if @articles.nil?
    end
end
