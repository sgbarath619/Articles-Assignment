class ArticleIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :topic, :published, :user_id, :created_at
end
