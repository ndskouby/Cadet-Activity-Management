require "test_helper"

class AuditActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get audit_activities_index_url
    assert_response :success
  end

  test "should get show" do
    get audit_activities_show_url
    assert_response :success
  end

  test "should get update" do
    get audit_activities_update_url
    assert_response :success
  end
end
