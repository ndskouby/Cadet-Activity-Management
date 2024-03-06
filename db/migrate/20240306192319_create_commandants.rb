class CreateCommandants < ActiveRecord::Migration[7.1]
  def change
    create_table :commandants do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
