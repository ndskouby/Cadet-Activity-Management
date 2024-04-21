# frozen_string_literal: true

class RenameUnitToUnitNameInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :unit, :unit_name
  end
end
