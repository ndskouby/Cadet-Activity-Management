# frozen_string_literal: true

class MinorUnit < ApplicationRecord
  belongs_to :major_unit
end
