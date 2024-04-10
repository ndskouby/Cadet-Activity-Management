class AddUnitToTrainingActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :training_activities, :unit_id, :integer
  end
end
