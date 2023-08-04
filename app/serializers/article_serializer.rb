class ArticleSerializer < ActiveModel::Serializer

  include Rails.application.routes.url_helpers

  attributes :id, :title, :topic, :text, :likes, :comments_cnt, :views, :user_id, :created_at, :updated_at, :image_url 

  def image_url
    if object.image.attached?
      url_for(object.image) 
      # rails_representation_url(object.image, only_path: true) 
    else
      ""
    end
  end

  private
  def default_url_options
    Rails.application.config.default_url_options
  end
end
