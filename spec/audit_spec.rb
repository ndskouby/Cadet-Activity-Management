require 'rails_helper'

RSpec.feature "AuditActivities", type: :feature do
  scenario "User visits the audit activities page" do
    visit audit_activities_index_path

    expect(current_path).to eq(audit_activities_index_path)
    # Additional expectations can be added here to verify page content
  end

  scenario "User visits the audit activities page with data" do
    training_activity = create(:training_activity)
    visit audit_activities_index_path

    expect(page).to have_content(training_activity.title)
    expect(page).to have_content(training_activity.activity_type)
    expect(page).to have_content(training_activity.status)
  end

  scenario "User visit audit_activities_show page for more info" do
    training_activity = create(:training_activity)
    visit audit_activities_show_path(id: training_activity.id)

    expect(page).to have_content(training_activity.title)
    expect(page).to have_content(training_activity.start_time)
    expect(page).to have_content(training_activity.end_time)
  end

  scenario "User click improve event" do
    training_activity = create(:training_activity)
    visit improve_reason_audit_activity_path(id: training_activity.id)

    expect(current_path).to eq(improve_reason_audit_activity_path(id: training_activity.id))
  end
end

RSpec.describe AuditActivitiesController, type: :controller do
  describe "POST #approve" do
    let!(:training_activity) { create(:training_activity, status: "Pending") }

    it "approves the training activity(Pending) and creates a status log" do
      post :approve, params: { id: training_activity.id }

      training_activity.reload # Reload the object from the database

      # Check that the training_activity's status is updated to "Approved"
      expect(training_activity.status).to eq("2nd Approval Needed")

      # Check that a TrainingActivityStatusLog record is created with status "Approved"
      status_log = TrainingActivityStatusLog.find_by(training_activity_id: training_activity.id)
      expect(status_log).not_to be_nil
      expect(status_log.status).to eq("2nd Approval Needed")

      # Verify redirection to audit_activities_path
      expect(response).to redirect_to(audit_activities_path)
    end
  end
end

RSpec.describe AuditActivitiesController, type: :controller do
  describe "POST #approve" do
    let!(:training_activity) { create(:training_activity, status: "2nd Approval Needed") }

    it "approves the training activity(2nd Approval Needed) and creates a status log" do
      post :approve, params: { id: training_activity.id }

      training_activity.reload # Reload the object from the database

      # Check that the training_activity's status is updated to "Approved"
      expect(training_activity.status).to eq("3rd Approval Needed")

      # Check that a TrainingActivityStatusLog record is created with status "Approved"
      status_log = TrainingActivityStatusLog.find_by(training_activity_id: training_activity.id)
      expect(status_log).not_to be_nil
      expect(status_log.status).to eq("3rd Approval Needed")

      # Verify redirection to audit_activities_path
      expect(response).to redirect_to(audit_activities_path)
    end
  end
end

RSpec.describe AuditActivitiesController, type: :controller do
  describe "POST #approve" do
    let!(:training_activity) { create(:training_activity, status: "3rd Approval Needed") }

    it "approves the training activity(3rd Approval Needed) and creates a status log" do
      post :approve, params: { id: training_activity.id }

      training_activity.reload # Reload the object from the database

      # Check that the training_activity's status is updated to "Approved"
      expect(training_activity.status).to eq("Approved")

      # Check that a TrainingActivityStatusLog record is created with status "Approved"
      status_log = TrainingActivityStatusLog.find_by(training_activity_id: training_activity.id)
      expect(status_log).not_to be_nil
      expect(status_log.status).to eq("Approved")

      # Verify redirection to audit_activities_path
      expect(response).to redirect_to(audit_activities_path)
    end
  end
end

RSpec.describe AuditActivitiesController, type: :controller do
  describe "POST #approve" do
    let!(:training_activity) { create(:training_activity, status: "Illegal Status") }

    it "approves the training activity(Illegal Status)" do
      post :approve, params: { id: training_activity.id }
      expect(response).to redirect_to(audit_activities_path)
    end
  end
end

RSpec.describe AuditActivitiesController, type: :controller do
  describe "POST #improve" do
    let!(:training_activity) { create(:training_activity) }

    it "Ask improvment for the training activity and creates a status log" do
      post :improve, params: { id: training_activity.id }

      training_activity.reload # Reload the object from the database

      # Check that the training_activity's status is updated to "Approved"
      expect(training_activity.status).to eq("Improvement Needed")

      # Check that a TrainingActivityStatusLog record is created with status "Approved"
      status_log = TrainingActivityStatusLog.find_by(training_activity_id: training_activity.id)
      expect(status_log).not_to be_nil
      expect(status_log.status).to eq("Improvement Needed")

      # Verify redirection to audit_activities_path
      expect(response).to redirect_to(audit_activities_path)
    end
  end
end
