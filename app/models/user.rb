class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    super
  end

  has_many :articles, class_name: "Article", foreign_key: "user_id", dependent: :destroy

  # we r following
  has_many :followed_users, class_name: "FollowRelation", foreign_key: "follower_id", dependent: :destroy
  has_many :followees, through: :followed_users, dependent: :destroy
  
  # following us
  has_many :following_users, class_name: "FollowRelation", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :following_users, dependent: :destroy

end
