class AddMajorUnitIdToMinorUnit < ActiveRecord::Migration[7.1]
  def change
    add_column :minor_units, :major_unit_id, :string
  end
end
