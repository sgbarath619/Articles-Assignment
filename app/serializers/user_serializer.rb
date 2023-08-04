class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :created_at, :follower_cnt, :followee_cnt, :liked_articles, :articles, 

  def articles
    # object.articles.map do |article| 
    # {
    #   id: article.id
    # }
    # end
    object.articles.map{|ar| ar.id} 
  end

  def follower_cnt
    object.followers.count()
  end
  def followee_cnt
    object.followees.count()
  end
end
