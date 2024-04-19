class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :major, :string
    add_column :users, :minor, :string
    add_column :users, :unit, :string
  end
end
