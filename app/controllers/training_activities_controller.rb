# frozen_string_literal: true

class TrainingActivitiesController < ApplicationController
  include TrainingActivitiesHelper
  before_action :set_training_activity, only: %i[show edit update destroy]

  # GET /training_activities
  def index
    @training_activities = TrainingActivity.all
    @activities_by_type = TrainingActivity.group(:priority, :status).count
  end

  def show; end

  # GET /training_activities/new
  def new
    @training_activity = TrainingActivity.new
  end

  # POST /training_activities
  def create
    @training_activity = TrainingActivity.new(training_activity_params)
    @training_activity.current_user = current_user
    @training_activity.update(user_id: session[:user_id])

    respond_to do |format|
      if @training_activity.save
        handle_successful_save(format)
      else
        handle_failed_save(format)
      end
    end
  end

  # GET /training_activities/1/edit
  def edit; end

  # PATCH/PUT /training_activities/1
  def update
    if @training_activity.update(training_activity_params)
      redirect_to @training_activity, notice: 'Training Activity as successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /training_activities/1
  def destroy
    @training_activity.destroy
    redirect_to training_activities_url, notice: 'Training Activity was successfully destroyed.'
  end

  # These have not been implemented yet, placeholder functions for when audit is merged
  #   def minor_unit_approval
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.submit_for_major_unit_approval!
  #     TrainingActivitiesMailer.major_unit_approval(@training_activity).deliver_now
  #   end
  #
  #   def major_unit_approval
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.submit_for_commandant_approval!
  #     TrainingActivitiesMailer.commandant_approval(@training_activity).deliver_now
  #   end
  #
  #   def minor_unit_revision_required(params[:id])
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.require_minor_unit_revision!
  #     TrainingActivitiesMailer.minor_unit_revision(@training_activity).deliver_now
  #   end
  #
  #   def major_unit_revision_required(params[:id])
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.require_major_unit_revision!
  #     TrainingActivitiesMailer.major_unit_revision(@training_activity).deliver_now
  #   end
  #
  #   def submitter_revision_required(params[:id])
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.require_submitter_revision!
  #     TrainingActivitiesMailer.submitter_revision(@training_activity).deliver_now
  #   end
  #
  #   def approved
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.approve!
  #     TrainingActivitiesMailer.approved(@training_activity).deliver_now
  #   end
  #
  #   def rejected
  #     @training_activity = TrainingActivity(params[:id])
  #     @training_activity.reject!
  #     TrainingActivitiesMailer.rejected(@training_activity).deliver_now
  #   end

  private

  def set_training_activity
    @training_activity = TrainingActivity.find(params[:id])
  end

  def training_activity_params
    params.require(:training_activity).permit(:name, :date, :time, :location, :priority, :justification,
                                              :opord_upload, competency_ids: [])
  end
end
