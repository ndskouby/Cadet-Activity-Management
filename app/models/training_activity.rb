# frozen_string_literal: true

class TrainingActivity < ApplicationRecord
  include AASM

  has_one_attached :opord_upload
  has_and_belongs_to_many :competencies

  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :time, presence: true, inclusion: { in: %w[MA AA] }
  validates :location, presence: true
  validates :priority, presence: true
  validates :justification, presence: true

  validate :validate_date
  validate :validate_competencies
  validate :validate_opord_upload_size
  validate :validate_opord_upload_type

  aasm column: 'status' do
    state :pending_minor_unit_approval, initial: true, display: 'Pending Minor Unit Approval'
    state :pending_major_unit_approval, display: 'Pending Major Unit Approval'
    state :pending_commandant_approval, display: 'Pending Commandant Approval'
    state :approved, display: 'Approved'
    state :revision_required_by_submitter, display: 'Revision Required by Submitter'
    state :revision_required_by_minor_unit, display: 'Revision Required by Minor Unit'
    state :revision_required_by_major_unit, display: 'Revision Required by Major Unit'
    state :rejected, display: 'Rejected'

    event :submit_for_major_unit_approval do
      transitions from: :pending_minor_unit_approval, to: :pending_major_unit_approval
    end

    event :submit_for_commandant_approval do
      transitions from: :pending_major_unit_approval, to: :pending_commandant_approval
    end

    event :approve do
      transitions from: :pending_commandant_approval, to: :approved
    end

    event :require_minor_unit_revision do
      transitions from: %i[pending_major_unit_approval pending_commandant_approval],
                  to: :revision_required_by_minor_unit
    end

    event :require_major_unit_revision do
      transitions from: :pending_commandant_approval, to: :revision_required_by_major_unit
    end

    event :require_submitter_revision do
      transitions from: :pending_minor_unit_approval, to: :revision_required_by_submitter
    end

    event :resubmit_after_revision do
      transitions from: :revision_required_by_submitter, to: :pending_minor_unit_approval,
                  guard: :revisions_made?

      transitions from: :revision_required_by_minor_unit, to: :pending_major_unit_approval,
                  guard: :revisions_made?

      transitions from: :revision_required_by_major_unit, to: :pending_commandant_approval,
                  guard: :revisions_made?
    end

    event :reject do
      transitions from: %i[pending_minor_unit_approval pending_major_unit_approval pending_commandant_approval revision_required_by_submitter revision_required_by_minor_unit revision_required_by_major_unit],
                  to: :rejected
    end
  end

  private

  def validate_date
    # Check if date is in the future
    errors.add(:date, 'must be in the future.') if date < Date.today

    # Check if year is four digits.
    return if date.year.to_s.length == 4

    errors.add(:date, 'year must be four digits.')
  end

  def validate_competencies
    # Only up to 3 competencies can be selected
    return unless competency_ids.count > 3

    errors.add(:competency_ids, 'You can select up to 3 competencies.')
  end

  def validate_opord_upload_size
    return unless opord_upload.attached? && opord_upload.blob.byte_size > 5.megabytes

    errors.add(:opord_upload, 'is too large. Maximum size is 5MB.')
  end

  def validate_opord_upload_type
    return unless opord_upload.attached? && !opord_upload.content_type.in?(%w[application/pdf])

    errors.add(:opord_upload, 'must be a PDF file.')
  end
end
