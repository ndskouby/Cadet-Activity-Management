# frozen_string_literal: true

class TrainingActivity < ApplicationRecord
  before_create :set_default_status
  validate :end_time_not_before_start_time
  validates :title, presence: true
  validates :activity_type, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  private

  def set_default_status
    self.status ||= 'Pending'
  end

  def end_time_not_before_start_time
    return if start_time.nil? || end_time.nil?

    return unless end_time < start_time

    errors.add(:end_time, 'must be after the start time')
  end
end
