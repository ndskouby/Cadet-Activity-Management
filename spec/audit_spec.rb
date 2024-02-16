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
