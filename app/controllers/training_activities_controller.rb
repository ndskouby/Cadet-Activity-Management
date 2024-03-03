class TrainingActivitiesController < ApplicationController
  before_action :set_training_activity, only: %i[show edit update destroy]

  # GET /training_activities
  def index
    @training_activities = TrainingActivity.all
  end

  def show; end

  # GET /training_activities/new
  def new
    @training_activity = TrainingActivity.new
  end

  # POST /training_activities
  def create
    @training_activity = TrainingActivity.new(training_activity_params)

    respond_to do |format|
      if @training_activity.save
        format.html { redirect_to @training_activity, notice: 'Training Activity was successfully created.' }
      else
        if params[:training_activity][:competency_ids]
          @training_activity.competency_ids = params[:training_activity][:competency_ids].reject(&:blank?)
        end
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('training_activity_form', partial: 'training_activities/form',
                                                                              locals: { training_activity: @training_activity })
        end
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

  private

  def set_training_activity
    @training_activity = TrainingActivity.find(params[:id])
  end

  def training_activity_params
    params.require(:training_activity).permit(:name, :date, :time, :location, :priority, :justification,
                                              :opord_upload, competency_ids: [])
  end
end
