class ArticleSerializer < ActiveModel::Serializer

  attributes :id, :title, :topic, :text, :likes, :comments_cnt, :views, :user_id, :image
end
