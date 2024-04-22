# frozen_string_literal: true

class TrainingActivitiesMailer < ApplicationMailer
  def pending_approval_notification(training_activity, user)
    @training_activity = training_activity
    @user = user
    mail(to: user.email, subject: 'Training Activity Pending Your Approval')
  end

  def revision_notification(training_activity)
    @training_activity = training_activity
    mail(to: training_activity.user.email, subject: 'Training Activity Needs Your Revision')
  end

  def rejected_notification(training_activity)
    @training_activity = training_activity
    mail(to: training_activity.user.email, subject: 'Training Activity Rejected')
  end
end
