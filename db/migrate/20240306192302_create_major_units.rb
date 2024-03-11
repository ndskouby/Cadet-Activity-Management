# frozen_string_literal: true

class CreateMajorUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :major_units do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
