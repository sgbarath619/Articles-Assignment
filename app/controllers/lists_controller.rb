class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[ show add remove deletelist ]
  before_action :verify_user, only:[ :add, :remove, :deletelist]

  def mylists
    render json: current_user.lists.all, each_serializer:ListSerializer, status: :ok
  end

  def show
    render json: @list, status: :ok
  end

  def create
    list = current_user.lists.build(list_params);
    if list.save
      render json: list, status: :created
    else
      render json: list.errors, status: :unprocessable_entity
    end
  end

  def add 
    @list.articles.push(params[:article_id].to_i)
    if @list.save
      render json: @list, status: :ok
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def remove
    @list.articles.delete(params[:article_id].to_i)
    if @list.save
      render json: @list, status: :ok
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def deletelist
    @list.destroy
    render json: {message: "Deleted successfully"}, status: :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :user_id)
  end

  def verify_user
    list = current_user.lists.find_by(id: params[:id])
    render json: {message: "Not authorized to edit this list"},status: :unprocessable_entity if list.nil?
  end

end
