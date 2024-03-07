class ActivityHistory < ApplicationRecord
  belongs_to :training_activity
  belongs_to :user
end
