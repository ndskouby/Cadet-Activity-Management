class AuditActivitiesController < ApplicationController
  def index
    @training_activities = TrainingActivity.all.order(:id)
  end

  def show
    @training_activity = TrainingActivity.find_by(id: params[:id])
    @training_activity_status_logs = TrainingActivityStatusLog.where(training_activity_id: params[:id]).order(created_at: :desc)
  end

  def approve
    # get activity
    training_activity = TrainingActivity.find_by(id: params[:id])
    # update training_activity status
    case training_activity.status
    when "Pending", "Resubmitted"
      upd_status = "2nd Approval Needed"
    when "2nd Approval Needed"
      upd_status = "3rd Approval Needed"
    when "3rd Approval Needed"
      upd_status = "Approved"
    else
      redirect_to audit_activities_path, notice: "[Error] The event are not allowed to be approved now!"
      return
    end
    training_activity.update(status: upd_status)
    # insert a log into training_activity_log
    TrainingActivityStatusLog.create(training_activity_id: params[:id], updated_by: "user", status: upd_status, reason: "")

    redirect_to audit_activities_path, notice: "Approved Successfully!"
  end

  def improve_reason
    @training_activity = TrainingActivity.find_by(id: params[:id])
    @training_activity_status_log = TrainingActivityStatusLog.new
  end

  def improve
    # update status
    training_activity = TrainingActivity.find_by(id: params[:id])
    training_activity.update(status: "Improvement Needed")
    # insert into log
    training_activity_status_log = TrainingActivityStatusLog.new(training_activity_id: params[:id], status: "Improvement Needed", updated_by: "user", reason: params[:reason])

    if training_activity_status_log.save
      redirect_to audit_activities_path, notice: "Improvement Asked."
    else
      redirect_to audit_activities_path, notice: "Failed."
    end
  end

end
