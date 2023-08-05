class ArticleIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :topic, :user_id, :created_at
end
