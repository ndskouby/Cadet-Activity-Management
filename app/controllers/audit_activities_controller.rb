# frozen_string_literal: true

class AuditActivitiesController < ApplicationController
  include AuditActivitiesHelper
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

    success = approval_success

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Approved.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to approve Training Activity.'
    end
  end

  def improve
    @training_activity.current_user = current_user

    success = improve_success

    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Requested Revision for Training Activity.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to Request Revision for Training Activity.'
    end
  end

  def reject
    @training_activity = TrainingActivity.find(params[:id])
    @training_activity.current_user = current_user
    @training_activity.comment = params[:comment]
    success = @training_activity.reject!
    
    if success
      redirect_to audit_activity_path(@training_activity), notice: 'Training Activity Rejected.'
    else
      redirect_to audit_activity_path(@training_activity), alert: 'Failed to reject Training Activity.'
    end
  end

  def resubmit
    @training_activity.current_user = current_user

    success = resubmit_success

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
