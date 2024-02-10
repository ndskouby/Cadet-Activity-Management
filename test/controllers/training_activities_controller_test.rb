require "test_helper"

class TrainingActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @training_activity = training_activities(:one)
  end

  test "should get index" do
    get training_activities_url
    assert_response :success
  end

  test "should get show" do
    get training_activity_url(@training_activity)
    assert_response :success
  end

  test "should get new" do
    get new_training_activity_url
    assert_response :success
  end

  test "should create training_activity" do
    assert_difference('TrainingActivity.count') do
      post training_activities_url, params: { training_activity: { title: 'New Training', activity_type: 'Military', description: 'Description', start_time: '2024-02-09', end_time: '2024-02-10', status: 'Pending' } }
    end

    assert_redirected_to training_activity_url(TrainingActivity.last)
  end

  test "should get edit" do
    get edit_training_activity_url(@training_activity)
    assert_response :success
  end

  test "should update training_activity" do
    patch training_activity_url(@training_activity), params: { training_activity: { title: 'Updated Title' } }
    assert_redirected_to training_activity_url(@training_activity)
    @training_activity.reload
    assert_equal 'Updated Title', @training_activity.title
  end

  test "should destroy training_activity" do
    assert_difference('TrainingActivity.count', -1) do
      delete training_activity_url(@training_activity)
    end

    assert_redirected_to training_activities_url
  end
end
