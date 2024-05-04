# frozen_string_literal: true

class AuditActivitiesController < ApplicationController
  include AuditActivitiesHelper
  before_action :set_training_activity, only: %i[show approve improve reject resubmit cancel]

  def index
    # puts current_user.units
    unit_list = [current_user.unit] + current_user.unit.all_descendants
    # unit_list.each do |unit|
    #   puts "Unit Name: #{unit.name}, Unit ID: #{unit.id}"
    # end
    @training_activities = TrainingActivity.includes(:activity_histories).where(unit: unit_list)
  end

  def show
    @training_activity = TrainingActivity.find(params[:id])
    @activity_histories = @training_activity.activity_histories.order(created_at: :desc)
  end

  def approve
    @training_activity.current_user = current_user

    success = approval_success

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Approved.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to approve Training Activity.'
    end
  end

  def handle_action(action_method, notice, alert)
    @training_activity.current_user = current_user
    @training_activity.comment = params[:comment]
    success = send(action_method)
    if success
      redirect_to(audit_activity_path(@training_activity), notice:)
    else
      redirect_to audit_activity_path(@training_activity), alert:
    end
  end

  def improve
    handle_action(:improve_success, 'Requested Revision for Training Activity.', 'Failed to Request Revision for Training Activity.')
  end

  def reject
    handle_action(:reject_success, 'Training Activity Rejected.', 'Failed to reject Training Activity.')
  end

  def resubmit
    handle_action(:resubmit_success, 'Training Activity Resubmitted.', 'Failed to resubmit Training Activity.')
  end

  def cancel
    handle_action(:cancel_success, 'Training Activity Cancelled.', 'Failed to cancel Training Activity.')
  end

  private

  def set_training_activity
    @training_activity = TrainingActivity.find(params[:id])
  end
end
