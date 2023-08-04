class AddLikedArticlesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :liked_articles, :integer, array: true, default: []
  end
end
