# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :parent, optional: true, foreign_key: :parent_id, class_name: 'Unit'

  def children
    Unit.where(parent_id: id)
  end

  def units
    return [self] + parent.units if parent

    [self]
  end

  def get_parent_by_cat(cat)
    raise ArgumentError, 'This method should be used by an outfit level unit only.' unless self.cat == 'outfit'

    case cat
    when 'minor'
      parent
    when 'major'
      parent&.parent
    when 'cmdt'
      parent&.parent&.parent
    else
      raise ArgumentError, 'Category should be minor, major, or cmdt.'
    end
  end

  # Scope to get units where cat equals 'outfit' and name is not blank or 'Delta Co'
  scope :outfit_units, -> { where(cat: 'outfit').where.not(name: [nil, '', 'Delta Co']) }
end
