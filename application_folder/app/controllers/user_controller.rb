class UserController < ApplicationController
  # require 'json'

  before_action :set_user, only: %i[ show follow unfollow ]
  before_action :authenticate_user!, except: [:index, :show]  

  def index
    if user_signed_in? 
      @users = User.where( "id != #{current_user.id}")
    else
      @users = User.all
    end
    render json: @users, status: :ok
  end
  
  def show
    render json: @user, status: :ok
  end
  
  def myprofile
    render json: current_user, status: :ok
  end

  def follow
    if current_user.id == @user.id 
      render json: {message: "Bad parameters"}, status: :unprocessable_entity
    elsif current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).count() != 0
      render json: {message: "Already following"}, status: :unprocessable_entity
    else
      FollowRelation.create_or_find_by(follower_id: current_user.id, followee_id: @user.id) 
      render json: {message: "Followed Successfully"}, status: :ok
    end
  end
  
  def unfollow
    if current_user.id == @user.id
      render json: {message: "Bad parameters"}, status: :unprocessable_entity
    elsif current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).count() == 0
      render json: {message: "Not following, cannot unfollow"}, status: :unprocessable_entity
    else
      current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
      render json: {message: "Unfollowed Successfully"}, status: :ok
    end
  end

  def followers
    followers_ids = current_user.following_users.map{|d| d.followee_id}
    render json: followers_ids, status:  :ok
    # User.where(id: )
  end

  def following
    following_ids = current_user.followed_users.map{|d| d.followee_id}
    render json: following_ids, status:  :ok
  end

  def add_liked_article
    if params[:id].present? and (not current_user.liked_articles.include? params[:id].to_i)
      current_user.liked_articles.push(params[:id])
      article = Article.find(params[:id])
      article.likes += 1

      if current_user.save
        article.save
        render json: {user_liked_articles: current_user.liked_articles, article_like_count: article.likes}, status: :ok
      else
        render json: current_user.errors, status: :unprocessable_entity
      end
    else 
      render json: {message: "Already liked"}, status: :ok
    end
  end

  def remove_liked_article
    if params[:id].present? and current_user.liked_articles.include? params[:id].to_i
      current_user.liked_articles.delete(params[:id].to_i)
      article = Article.find(params[:id])
      article.likes -= 1

      if current_user.save
        article.save
        render json: {user_liked_articles: current_user.liked_articles, article_like_count: article.likes}, status: :ok
      else
        render json: current_user.errors, status: :unprocessable_entity
      end
    else 
      render json: {message: "Not liked Article"}, status: :ok
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
