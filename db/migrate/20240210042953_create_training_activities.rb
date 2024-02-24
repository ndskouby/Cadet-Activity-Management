# frozen_string_literal: true

class CreateTrainingActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :training_activities do |t|
      t.string :title
      t.string :activity_type
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :status

      t.timestamps
    end
  end
end
