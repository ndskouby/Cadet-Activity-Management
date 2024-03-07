# frozen_string_literal: true

class AddMinorUnitIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :minor_unit_id, :string
  end
end
