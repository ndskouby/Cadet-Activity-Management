class CreateTrainingActivityStatusLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :training_activity_status_logs do |t|
      t.integer :training_activity_id
      t.string :status
      t.string :updated_by
      t.string :reason

      t.timestamps
    end
  end
end
