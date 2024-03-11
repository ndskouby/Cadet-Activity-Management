# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :parent, optional: true, foreign_key: :parent_id, class_name: "Unit"
end
