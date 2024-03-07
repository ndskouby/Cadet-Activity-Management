# frozen_string_literal: true

class AddUserIdToTrainingActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :training_activities, :user_id, :string
  end
end
