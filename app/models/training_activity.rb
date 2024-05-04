# frozen_string_literal: true

class TrainingActivity < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :unit

  attr_accessor :current_user, :comment

  has_one_attached :opord_upload
  has_and_belongs_to_many :competencies
  has_many :activity_histories, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :time, presence: true, inclusion: { in: %w[MA AA] }
  validates :location, presence: true
  validates :priority, presence: true
  validates :justification, presence: true
  validates :unit_id, presence: true

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
    state :cancelled, display: 'Cancelled'

    # Event: Approved by Minor Unit; Submitted for Major Unit Approval
    event :submit_for_major_unit_approval do
      transitions from: :pending_minor_unit_approval, to: :pending_major_unit_approval do
        success do
          log_activity_history('submitted_for_major_unit_approval')
          send_pending_approval_email('major')
        end
      end
    end

    # Event: Approved by Major Unit; Submitted for Commandant Approval
    event :submit_for_commandant_approval do
      transitions from: :pending_major_unit_approval, to: :pending_commandant_approval do
        success do
          log_activity_history('submitted_for_commandant_approval')
          send_pending_approval_email('cmdt')
        end
      end
    end

    # Event: Approved by Commandant; Training Activity Approved
    event :approved do
      transitions from: :pending_commandant_approval, to: :approved do
        success do
          log_activity_history('approved', comment)
        end
      end
    end

    # Revision Required by Submitter; Requested by Minor Unit
    event :request_submitter_revision do
      transitions from: %i[pending_minor_unit_approval pending_major_unit_approval pending_commandant_approval revision_required_by_minor_unit revision_required_by_major_unit],
                  to: :revision_required_by_submitter do
        success do
          log_activity_history('revision_required_by_submitter', comment)
          send_revision_email
        end
      end
    end

    # Revision Required by Minor Unit; Requested by Major Unit
    event :request_minor_unit_revision do
      transitions from: %i[pending_major_unit_approval pending_commandant_approval revision_required_by_major_unit], to: :revision_required_by_minor_unit do
        success do
          log_activity_history('revision_required_by_minor_unit', comment)
          send_revision_email
        end
      end
    end

    # Revision Required by Major Unit; Requested by Commandant
    event :request_major_unit_revision do
      transitions from: %i[pending_commandant_approval], to: :revision_required_by_major_unit do
        success do
          log_activity_history('revision_required_by_major_unit', comment)
          send_revision_email
        end
      end
    end

    # Event: Submitted for Minor Unit Approval from Revision Required by Submitter
    event :submit_for_minor_unit_approval do
      transitions from: :revision_required_by_submitter, to: :pending_minor_unit_approval do
        success do
          log_activity_history('revision_submitted_for_minor_unit_approval', comment)
          send_pending_approval_email('minor')
        end
      end
    end

    # Event: Submitted for Major Unit Approval from Revision Required by Minor Unit
    event :submit_for_major_unit_approval_from_minor_unit_revision do
      transitions from: :revision_required_by_minor_unit, to: :pending_major_unit_approval do
        success do
          log_activity_history('revision_submitted_for_major_unit_approval', comment)
          send_pending_approval_email('major')
        end
      end
    end

    # Event: Submitted for Commandant Approval from Revision Required by Major Unit
    event :submit_for_commandant_approval_from_major_unit_revision do
      transitions from: :revision_required_by_major_unit, to: :pending_commandant_approval do
        success do
          log_activity_history('revision_submitted_for_commandant_approval', comment)
          send_pending_approval_email('cmdt')
        end
      end
    end

    # Event: Rejected
    event :reject do
      transitions from: %i[pending_minor_unit_approval pending_major_unit_approval pending_commandant_approval], to: :rejected do
        success do
          log_activity_history('rejected', comment)
          send_rejected_email
        end
      end
    end

    # Event: Cancelled
    event :cancel do
      transitions from: %i[pending_minor_unit_approval pending_major_unit_approval pending_commandant_approval request_minor_unit_revision request_submitter_revision request_major_unit_revision approved],
                  to: :cancelled do
        success do
          log_activity_history('cancelled', comment)
        end
      end
    end
  end

  after_create :send_initial_approval_request, if: -> { status == 'pending_minor_unit_approval' }

  # Send email to minor unit staff when activity is created
  def send_initial_approval_request
    send_pending_approval_email('minor')
  end

  def log_activity_history(event, comment = 'No Reason Provided.')
    message = case event
              when 'activity_created'
                "Training Activity Created by #{current_user.first_name} (#{current_user.email}). Requesting Minor Unit Approval."
              when 'submitted_for_major_unit_approval'
                "Minor Unit Approval by #{current_user.first_name} (#{current_user.email}). Requesting Major Unit Approval."
              when 'submitted_for_commandant_approval'
                "Major Unit Approval by #{current_user.first_name} (#{current_user.email}). Requesting Commandant Approval."
              when 'approved'
                "Commandant Approval by #{current_user.first_name} (#{current_user.email}). Training Activity Approved."
              when 'revision_required_by_submitter'
                "Revision Required by #{current_user.first_name} (#{current_user.email}). Requesting Submitter Revision."
              when 'revision_required_by_minor_unit'
                "Revision Required by #{current_user.first_name} (#{current_user.email}). Requesting Minor Unit Revision."
              when 'revision_required_by_major_unit'
                "Revision Required by #{current_user.first_name} (#{current_user.email}). Requesting Major Unit Revision."
              when 'revision_submitted_for_minor_unit_approval'
                "Revision Submitted by #{current_user.first_name} (#{current_user.email}). Requesting Minor Unit Approval."
              when 'revision_submitted_for_major_unit_approval'
                "Revision Submitted by #{current_user.first_name} (#{current_user.email}). Requesting Major Unit Approval."
              when 'revision_submitted_for_commandant_approval'
                "Revision Submitted by #{current_user.first_name} (#{current_user.email}). Requesting Commandant Approval."
              when 'rejected'
                "Rejected by #{current_user.first_name} (#{current_user.email}). #{comment.presence || 'No comment provided.'}"
              when 'cancelled'
                "Cancelled by #{current_user.first_name} (#{current_user.email}). #{comment.presence || 'No comment provided.'}"
              else
                "#{event.humanize} by #{current_user.first_name} (#{current_user.email})."
              end

    activity_histories.create(event: message, user: current_user, comment:)
  end

  # Find users to send emails based on which upper level
  # param cat should be minor/major/cmdt
  def send_pending_approval_email(cat)
    goal_unit = unit.get_parent_by_cat(cat)

    return unless goal_unit

    # puts "goal unit: #{goal_unit.name}, unit_id: #{goal_unit.id}"
    staff_users = User.where('unit_id = ? AND unit_name LIKE ?', goal_unit.id, '%Staff%')
    # puts "Found staff_users: #{staff_users.map(&:email)}" # Check if users are correctly fetched

    staff_users.each do |user|
      # puts "Sending email to: #{user.email}, Unit ID: #{user.unit_id}" # Debug information
      TrainingActivitiesMailer.pending_approval_notification(self, user).deliver_later
    end
  end

  def send_revision_email
    # puts "Sending revision notification: #{user.email}"
    TrainingActivitiesMailer.revision_notification(self).deliver_later
  end

  def send_rejected_email
    TrainingActivitiesMailer.rejected_notification(self).deliver_later
  end

  private

  def validate_date
    errors.add(:date, 'must be in the future.') if date < Date.today
    errors.add(:date, 'year must be four digits.') unless date.year.to_s.length == 4
  end

  def validate_competencies
    # Only up to 3 competencies can be selected
    return unless competency_ids.count > 3

    errors.add(:competency_ids, 'You can only select up to 3 competencies.')
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
