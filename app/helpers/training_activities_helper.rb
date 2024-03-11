# frozen_string_literal: true

module TrainingActivitiesHelper
  def handle_successful_save(format)
    TrainingActivitiesMailer.minor_unit_approval(@training_activity).deliver_now
    @training_activity.log_activity_history('activity_created')
    format.html { redirect_to @training_activity, notice: 'Training Activity was successfully created.' }
  end

  def handle_failed_save(format)
    @training_activity.competency_ids = params[:training_activity][:competency_ids].reject(&:blank?) if params[:training_activity][:competency_ids]
    format.html { render :new, status: :unprocessable_entity }
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace('training_activity_form', partial: 'training_activities/form',
                                                                          locals: { training_activity: @training_activity })
    end
  end
end
