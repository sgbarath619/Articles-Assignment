class AddViewsleftToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :viewsleft, :integer, :default => 1
    add_column :users, :lastview, :date, :default => Date.yesterday
    #Ex:- :default =>''
  end
end
