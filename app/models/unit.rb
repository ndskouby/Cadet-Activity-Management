# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :parent, optional: true, foreign_key: :parent_id, class_name: 'Unit'

  def children
    Unit.where(parent_id: id)
  end

  def units
    return [name] + parent.units if parent

    [name]
  end
end
