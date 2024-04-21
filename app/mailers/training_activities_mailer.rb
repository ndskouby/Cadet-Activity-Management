# frozen_string_literal: true

class TrainingActivitiesMailer < ApplicationMailer
  def minor_unit_approval(model)
    @model = model
    @submitter = "#{model.user.first_name} #{model.user.last_name}"
    @body = "Cadet: #{@submitter} has created a new activity"

    mail(to: model.user.unit.parent.email, subject: 'New activity awaiting approval')
  end

  def pending_approval_notification(training_activity, user)
    @training_activity = training_activity
    @user = user
    mail(to: user.email, subject: 'Training Activity Pending Your Approval')
  end

  #  def commandant_approval(model)
  #  end
  #
  #  def minor_unit_revision(model)
  #  end
  #
  #  def major_unit_revision(model)
  #  end
  #
  #  def submitter_revision(model)
  #  end
  #
  #  def approved(model)
  #  end
  #
  #  def rejected(model)
  #  end
end
