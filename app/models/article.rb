class Article < ApplicationRecord

  has_one_attached :image

  belongs_to :user, class_name: "User", foreign_key: "user_id"
end
