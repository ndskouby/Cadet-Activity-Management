# frozen_string_literal: true

class TrainingActivitiesController < ApplicationController
  before_action :set_training_activity, only: %i[show edit update destroy]

  def index
    @training_activities = TrainingActivity.all
  end

  def show; end

  def new
    @training_activity = TrainingActivity.new
  end

  def create
    @training_activity = TrainingActivity.new(training_activity_params)
    # @training_activity.status = 'Pending'

    if @training_activity.save
      redirect_to @training_activity, notice: 'Training activity was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @training_activity.update(training_activity_params)
      redirect_to @training_activity, notice: 'Training activity was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @training_activity = TrainingActivity.find(params[:id])
    @training_activity.destroy
    redirect_to training_activities_url, notice: 'Training activity was successfully destroyed.'
  end

  private

  def set_training_activity
    @training_activity = TrainingActivity.find(params[:id])
  end

  def training_activity_params
    params.require(:training_activity).permit(:title, :activity_type, :description, :start_time, :end_time, :status)
  end
end
