# frozen_string_literal: true

class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string 'name'
      t.string 'cat'
      t.string 'email'
      t.integer 'parent_id'
      t.timestamps
    end

    add_column :users, :unit_id, :integer
    drop_table :major_units
    drop_table :minor_units
    drop_table :commandants
    remove_column :users, :minor_unit_id
  end
end
