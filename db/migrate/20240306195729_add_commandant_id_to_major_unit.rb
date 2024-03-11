# frozen_string_literal: true

class AddCommandantIdToMajorUnit < ActiveRecord::Migration[7.1]
  def change
    add_column :major_units, :commandant_id, :string
  end
end
