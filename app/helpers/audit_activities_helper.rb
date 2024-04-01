# frozen_string_literal: true

module AuditActivitiesHelper
  def approval_success
    case @training_activity.status
    when 'pending_minor_unit_approval'
      @training_activity.submit_for_major_unit_approval!
    when 'pending_major_unit_approval'
      @training_activity.submit_for_commandant_approval!
    when 'pending_commandant_approval'
      @training_activity.approved!
    end
  end

  def improve_success
    case @training_activity.status
    when 'pending_minor_unit_approval', 'revision_required_by_minor_unit'
      @training_activity.request_submitter_revision!
    when 'pending_major_unit_approval', 'revision_required_by_major_unit'
      @training_activity.request_minor_unit_revision!
    when 'pending_commandant_approval'
      @training_activity.request_major_unit_revision!
    end
  end

  def resubmit_success
    case @training_activity.status
    when 'revision_required_by_submitter'
      @training_activity.submit_for_minor_unit_approval!
    when 'revision_required_by_minor_unit'
      @training_activity.submit_for_major_unit_approval_from_minor_unit_revision!
    when 'revision_required_by_major_unit'
      @training_activity.submit_for_commandant_approval_from_major_unit_revision!
    end
  end

  def cancel_success
    case @training_activity.status
    when 'pending_minor_unit_approval'
      @training_activity.cancel!
    when 'pending_major_unit_approval'
      @training_activity.cancel!
    when 'pending_commandant_approval'
      @training_activity.cancel!
    when 'revision_required_by_minor_unit'
      @training_activity.cancel!
    when 'revision_required_by_major_unit'
      @training_activity.cancel!
    when 'revision_required_by_submitter'
      @training_activity.cancel!
    when 'approved'
      @training_activity.cancel!
    end
  end

  def reject_success
    case @training_activity.status
    when 'pending_minor_unit_approval'
      @training_activity.reject!
    when 'pending_major_unit_approval'
      @training_activity.reject!
    when 'pending_commandant_approval'
      @training_activity.reject!
    end
  end
end
