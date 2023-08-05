class AddViewhistoryToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :viewhistory, :integer, :array => true, :default => []
  end
end
