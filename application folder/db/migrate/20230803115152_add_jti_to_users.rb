class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :jti, :string, null: false
    add_index :users, :jti, unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
