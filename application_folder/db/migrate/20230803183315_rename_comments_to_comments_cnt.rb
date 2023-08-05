class RenameCommentsToCommentsCnt < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :comments, :comments_cnt
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
