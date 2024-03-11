class AuditActivitiesController < ApplicationController
  before_action :set_training_activity, only: %i[show approve improve reject resubmit cancel]

  def index
    @training_activities = TrainingActivity.includes(:activity_histories).all
  end

  def show
    @training_activity = TrainingActivity.find(params[:id])
    @activity_histories = @training_activity.activity_histories.order(created_at: :desc)
  end

  def approve
    @training_activity.current_user = current_user

    success = case @training_activity.status
              when 'pending_minor_unit_approval'
                @training_activity.submit_for_major_unit_approval!
              when 'pending_major_unit_approval'
                @training_activity.submit_for_commandant_approval!
              when 'pending_commandant_approval'
                @training_activity.approved!
              end

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Approved.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to approve Training Activity.'
    end
  end

  def improve
    @training_activity.current_user = current_user

    success = case @training_activity.status
              when 'pending_minor_unit_approval', 'revision_required_by_minor_unit'
                @training_activity.request_submitter_revision!
              when 'pending_major_unit_approval', 'revision_required_by_major_unit'
                @training_activity.request_minor_unit_revision!
              when 'pending_commandant_approval'
                @training_activity.request_major_unit_revision!
              end

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Requested Revision for Training Activity.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to Request Revision for Training Activity.'
    end
  end

  def reject
    @training_activity.current_user = current_user

    success = @training_activity.reject!

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Rejected.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to reject Training Activity.'
    end
  end

  def resubmit
    @training_activity.current_user = current_user

    success = case @training_activity.status
              when 'revision_required_by_submitter'
                @training_activity.submit_for_minor_unit_approval!
              when 'revision_required_by_minor_unit'
                @training_activity.submit_for_major_unit_approval_from_minor_unit_revision!
              when 'revision_required_by_major_unit'
                @training_activity.submit_for_commandant_approval_from_major_unit_revision!
              end

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Resubmitted.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to resubmit Training Activity.'
    end
  end

  def cancel
    @training_activity.current_user = current_user

    success = @training_activity.cancel!

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Cancelled.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to cancel Training Activity.'
    end
  end

  private

  def set_training_activity
    @training_activity = TrainingActivity.find(params[:id])
  end
end
