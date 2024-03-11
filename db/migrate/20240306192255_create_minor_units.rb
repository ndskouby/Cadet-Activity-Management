# frozen_string_literal: true

class CreateMinorUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :minor_units do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
