class CreateActivityHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_histories do |t|
      t.references :training_activity, null: false, foreign_key: true
      t.string :event
      t.text :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
