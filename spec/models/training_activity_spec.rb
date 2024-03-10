# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrainingActivity, type: :model do
  before(:each) do
    @training_activity = create(:training_activity)
    @user = create(:user)
    @training_activity.current_user = @user
  end

  after(:each) do
    ActiveRecord::Base.connection.execute('DELETE FROM competencies_training_activities')
  end

  # Validation Tests
  it 'is valid with valid attributes' do
    expect(@training_activity).to be_valid
  end

  it 'is invalid without a name' do
    training_activity = build(:training_activity, name: nil)
    expect(training_activity).not_to be_valid
  end

  it 'is invalid with a time outside of the specified options' do
    training_activity = build(:training_activity, time: 'Invalid Time')
    expect(training_activity).not_to be_valid
  end

  it 'is invalid with a date year of more than four digits' do
    training_activity = build(:training_activity, date: '20201-01-01')
    expect(training_activity).not_to be_valid
  end

  it 'is invalid with a date in the past' do
    training_activity = build(:training_activity, date: '2020-01-01')
    expect(training_activity).not_to be_valid
  end

  it 'is invalid with more than three competencies' do
    extra_competencies = create_list(:competency, 4)
    competency_ids = extra_competencies.map(&:id)
    
    training_activity = build(:training_activity, competencies: [])
    training_activity.competency_ids = competency_ids
  
    expect(training_activity).not_to be_valid
    expect(training_activity.errors[:competency_ids]).to include("You can only select up to 3 competencies.")
  end
  

  it 'is invalid with an opord_upload that is too large' do
    training_activity = build(:training_activity)
    file_path = Rails.root.join('spec', 'support', 'fixtures', 'largefile.pdf')
    training_activity.opord_upload.attach(
      io: File.open(file_path),
      filename: 'largefile.pdf',
      content_type: 'application/pdf'
    )
    expect(training_activity.opord_upload).to be_attached
    expect(training_activity.opord_upload.blob.byte_size).to be > 5.megabytes
    expect(training_activity).not_to be_valid
  end

  it 'is invalid with an opord_upload that is not a PDF' do
    training_activity = build(:training_activity)
    file_path = Rails.root.join('spec', 'support', 'fixtures', 'worddoc.doc')
    training_activity.opord_upload.attach(
      io: File.open(file_path),
      filename: 'lwordodc.doc',
      content_type: 'application/msword'
    )
    expect(training_activity.opord_upload).to be_attached
    expect(training_activity.opord_upload.content_type).not_to eq('application/pdf')
    expect(training_activity).not_to be_valid
  end

  #
  # Update Tests
  #
  describe 'updating a training activity' do
    it 'updates the name attribute' do
      @training_activity.save!
      new_name = 'New Name'
      @training_activity.update(name: new_name)
      expect(@training_activity.reload.name).to eq(new_name)
    end

    it 'updates the time attribute' do
      original_time = @training_activity.time
      new_time = original_time == 'MA' ? 'AA' : 'MA'

      @training_activity.update(time: new_time)

      expect(@training_activity.reload.time).to eq(new_time)
      expect(@training_activity.time).not_to eq(original_time)
    end

    it 'updates the location attribute' do
      new_location = 'New Location'
      @training_activity.update(location: new_location)
      expect(@training_activity.reload.location).to eq(new_location)
    end

    it 'updates the priority attribute' do
      new_priority = 'Career Readiness'
      @training_activity.update(priority: new_priority)
      expect(@training_activity.reload.priority).to eq(new_priority)
    end

    it 'updates the justification attribute' do
      new_justification = 'This is some edited justification for the training activity.'
      @training_activity.update(justification: new_justification)
      expect(@training_activity.reload.justification).to eq(new_justification)
    end

    it 'updates the competencies attribute' do
      new_competencies = [create(:competency), create(:competency)]
      @training_activity.update(competencies: new_competencies)
      expect(@training_activity.reload.competencies).to eq(new_competencies)
    end

    it 'updates the opord attribute' do
      new_opord = fixture_file_upload('spec/support/fixtures/file2.pdf', 'application/pdf')
      @training_activity.update(opord_upload: new_opord)

      @training_activity.reload

      expect(@training_activity.opord_upload).to be_attached
      expect(@training_activity.opord_upload.filename.to_s).to eq 'file2.pdf'
      expect(@training_activity.opord_upload.content_type).to eq 'application/pdf'
    end
  end

  #
  # Approval State Tests
  #
  describe 'status transitions' do
    context 'when status is pending_minor_unit_approval' do
      before do
        @training_activity = create(:training_activity, status: :pending_minor_unit_approval)
        @training_activity.current_user = @user
      end

      it 'transitions to pending_major_unit_approval' do
        @training_activity.submit_for_major_unit_approval!
        expect(@training_activity).to have_state(:pending_major_unit_approval)
      end
    end

    context 'when status is pending_major_unit_approval' do
      before do
        @training_activity = create(:training_activity, status: :pending_major_unit_approval)
        @training_activity.current_user = @user
      end

      it 'transitions to pending_commandant_approval' do
        @training_activity.submit_for_commandant_approval!
        expect(@training_activity).to have_state(:pending_commandant_approval)
      end
    end

    context 'when status is pending_commandant_approval' do
      before do
        @training_activity = create(:training_activity, status: :pending_commandant_approval)
        @training_activity.current_user = @user
      end

      it 'transitions to approved' do
        @training_activity.approved!
        expect(@training_activity).to have_state(:approved)
      end
    end

    context 'when status is revision_required_by_submitter' do
      before do
        @training_activity = create(:training_activity, status: :revision_required_by_submitter)
        @training_activity.current_user = @user
      end

      it 'transitions to pending_minor_unit_approval' do
        @training_activity.submit_for_minor_unit_approval
        expect(@training_activity).to have_state(:pending_minor_unit_approval)
      end
    end
  end
end
