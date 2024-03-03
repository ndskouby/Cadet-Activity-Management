class UpdateTrainingActivities < ActiveRecord::Migration[7.1]
  def change
    rename_column :training_activities, :title, :name

    remove_column :training_activities, :start_time, :datetime
    remove_column :training_activities, :end_time, :datetime
    add_column :training_activities, :date, :date
    add_column :training_activities, :time, :string

    # Add new fields
    add_column :training_activities, :location, :string
    add_column :training_activities, :priority, :string
    add_column :training_activities, :justification, :text

    create_table :competencies_training_activities, id: false do |t|
      t.belongs_to :training_activity, index: true, foreign_key: true
      t.belongs_to :competency, index: true, foreign_key: true
    end
  end
end
