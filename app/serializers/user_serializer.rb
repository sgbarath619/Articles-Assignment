class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :created_at, :follower_cnt, :followee_cnt, :viewsleft, :lastview, :liked_articles, :articles, :lists

  def articles
    object.articles.map{|ar| ar.id} 
  end
  
  def lists
    object.lists.map{|l| l.id}
  end

  def follower_cnt
    object.followers.count()
  end
  def followee_cnt
    object.followees.count()
  end
end
