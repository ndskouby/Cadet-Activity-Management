# frozen_string_literal: true

class Competency < ApplicationRecord
  has_and_belongs_to_many :training_activities
end
