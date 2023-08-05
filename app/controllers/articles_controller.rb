class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authenticate_user!, except:[:index, :toparticles]  
  before_action :verify_user, only:[:edit, :update, :destroy]

  # GET /articles
  def index
    
    @articles = Article.all
    @articles = @articles.where('title ilike ?', "%#{params[:title]}%" ) if params[:title].present?
    @articles = @articles.where('topic ilike ?', "%#{params[:topic]}%" ) if params[:topic].present?
    @articles = @articles.where('text ilike ?', "%#{params[:text]}%" ) if params[:text].present?
    
    @articles = @articles.where("created_at >= #{params[:start_date]}" ) if params[:start_date].present?
    @articles = @articles.where("created_at <= #{params[:end_date]}" ) if params[:end_date].present?

    @articles = @articles.where("likes >= #{params[:likes]}" ) if params[:likes].present?
    @articles = @articles.where("comments_cnt >= #{params[:comments_cnt]}" ) if params[:comments_cnt].present?
    @articles = @articles.where("views >= #{params[:views]}" ) if params[:views].present?

    @articles = @articles.where(user_id: params[:userid] ) if params[:userid].present?

    order = params.fetch('order',"desc")
    order = "desc" if order != "asc"
    order_by = params.fetch('order_by',"created_at")
    order_by = "created_at" if not ["created_at","likes","views"].include?(order_by)
    @articles = @articles.order("#{order_by} #{order.upcase}")

    @total = @articles.count()
    @total = [@total,1].max
    @page = params.fetch('pg',0).to_i 
    @cntperpage = params.fetch('perpage',@total).to_i
    
    @articles = @articles.limit(@cntperpage).offset(@page*@cntperpage)

    # render json: {articles: @articles, total: @total}, status: :ok
    render json: @articles, each_serializer:ArticleIndexSerializer, status: :ok
  end

  # GET /articles/1
  def show
    current_user.viewsleft += 1 if current_user.lastview < Date.today
    if @article.user_id == current_user.id
      render json: @article, status: :ok
    elsif current_user.viewsleft > 0
      #1 free view per day

      current_user.viewsleft -= 1
      current_user.save

      current_user.lastview = Date.today
      current_user.save
      @article.views += 1
      @article.save
      render json: @article, status: :ok
    else 
      render json: {message: "No views left"}, status: :ok
    end
  end

  # GET /articles/myarticles
  def myarticles
    @articles = current_user.articles.all.order(created_at: :desc)
    # @articles = @articles.map{ |article| 
    #   if article.image.attached? 
    #     article.as_json.merge(image_path: url_for(article.image))
    #   else
    #     article
    #   end
    # }
    render json: @articles, status: :ok
  end

  def recomended
    liked = current_user.liked_articles
    if liked.empty?
      @articles = Article.where("user_id != #{current_user.id}").order(likes: :desc)
    else
      liked = liked.map{|id| Article.find(id).user_id}
      @articles = Article.where(user_id: liked).order(likes: :desc)
    end
    render json: @articles, each_serializer:ArticleIndexSerializer, status: :ok
  end

  def topics
    topics = Article.all
    topics = topics.map{|ar| ar.topic}
    topics = topics.uniq
    render json: topics, status: :ok 
  end

  def toparticles
    articles = Article.all
    articles = articles.map{|a| {id: a.id, value: a.likes.to_i+a.comments_cnt.to_i+a.views.to_i}}
    articles = articles.sort_by{|a| -1*a[:value]}
    articles = articles.map{|a| Article.find(a[:id])}
    render json: articles, serializer:ArticleIndexSerializer, status: :ok
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
      params.require(:article).permit(:title, :topic, :text, :likes, :comments_cnt, :views, :user_id, :image)
    end


    def verify_user
      @articles = current_user.articles.find_by(id: params[:id])
      render json: {message: "Not authorized to edit this article"},status: :unprocessable_entity if @articles.nil?
    end
end
