require 'rails_helper'

RSpec.describe AuditActivitiesHelper, type: :helper do
  describe '#approval_success' do
    before do
      @training_activity = FactoryBot.create(:training_activity)
      helper.instance_variable_set(:@training_activity, @training_activity)
    end

    it 'submits for major unit approval when pending minor unit approval' do
      @training_activity.status = 'pending_minor_unit_approval'
      expect(@training_activity).to receive(:submit_for_major_unit_approval!)
      helper.approval_success
    end

    it 'submits for commandant approval when pending major unit approval' do
      @training_activity.status = 'pending_major_unit_approval'
      expect(@training_activity).to receive(:submit_for_commandant_approval!)
      helper.approval_success
    end

    it 'approves the activity when pending commandant approval' do
      @training_activity.status = 'pending_commandant_approval'
      expect(@training_activity).to receive(:approved!)
      helper.approval_success
    end
  end

  describe '#improve_success' do
    before do
      @training_activity = FactoryBot.create(:training_activity)
      helper.instance_variable_set(:@training_activity, @training_activity)
    end

    it 'requests submitter revision when in pending minor unit approval' do
      @training_activity.status = 'pending_minor_unit_approval'
      expect(@training_activity).to receive(:request_submitter_revision!)
      helper.improve_success
    end

    it 'requests submitter revision when in revision required by minor unit' do
      @training_activity.status = 'revision_required_by_minor_unit'
      expect(@training_activity).to receive(:request_submitter_revision!)
      helper.improve_success
    end

    it 'requests minor unit revision when in pending major unit approval' do
      @training_activity.status = 'pending_major_unit_approval'
      expect(@training_activity).to receive(:request_minor_unit_revision!)
      helper.improve_success
    end

    it 'requests minor unit revision when in revision required by major unit' do
      @training_activity.status = 'revision_required_by_major_unit'
      expect(@training_activity).to receive(:request_minor_unit_revision!)
      helper.improve_success
    end

    it 'requests major unit revision when in pending commandant approval' do
      @training_activity.status = 'pending_commandant_approval'
      expect(@training_activity).to receive(:request_major_unit_revision!)
      helper.improve_success
    end
  end

  describe '#resubmit_success' do
    before do
      @training_activity = FactoryBot.create(:training_activity)
      helper.instance_variable_set(:@training_activity, @training_activity)
    end

    it 'submits for minor unit approval from revision required by submitter' do
      @training_activity.status = 'revision_required_by_submitter'
      expect(@training_activity).to receive(:submit_for_minor_unit_approval!)
      helper.resubmit_success
    end

    it 'submits for major unit approval from revision required by minor unit' do
      @training_activity.status = 'revision_required_by_minor_unit'
      expect(@training_activity).to receive(:submit_for_major_unit_approval_from_minor_unit_revision!)
      helper.resubmit_success
    end

    it 'submits for commandant approval from revision required by major unit' do
      @training_activity.status = 'revision_required_by_major_unit'
      expect(@training_activity).to receive(:submit_for_commandant_approval_from_major_unit_revision!)
      helper.resubmit_success
    end
  end

  describe '#cancel_success' do
    before do
      @training_activity = FactoryBot.create(:training_activity)
      helper.instance_variable_set(:@training_activity, @training_activity)
    end

    it 'cancels the activity for each applicable status' do
      applicable_statuses = %w[
        pending_minor_unit_approval
        pending_major_unit_approval
        pending_commandant_approval
        revision_required_by_minor_unit
        revision_required_by_major_unit
        revision_required_by_submitter
        approved
      ]

      applicable_statuses.each do |status|
        @training_activity.status = status
        expect(@training_activity).to receive(:cancel!)
        helper.cancel_success
      end
    end
  end

  describe '#reject_success' do
    before do
      @training_activity = FactoryBot.create(:training_activity)
      helper.instance_variable_set(:@training_activity, @training_activity)
    end

    it 'rejects the activity for each applicable status' do
      applicable_statuses = %w[
        pending_minor_unit_approval
        pending_major_unit_approval
        pending_commandant_approval
      ]

      applicable_statuses.each do |status|
        @training_activity.status = status
        expect(@training_activity).to receive(:reject!)
        helper.reject_success
      end
    end
  end
end
