require "test_helper"

class TrainingActivityTest < ActiveSupport::TestCase
  test "should not save training activity without title" do
    training_activity = TrainingActivity.new
    assert_not training_activity.save, "Saved the training activity without a title"
  end

  test "should not save training activity without activity type" do
    training_activity = TrainingActivity.new(title: "Example", start_time: Time.now, end_time: Time.now + 1.hour)
    assert_not training_activity.save, "Saved the training activity without an activity type"
  end

  test "should not save training activity without start time" do
    training_activity = TrainingActivity.new(title: "Example", activity_type: "Workshop", end_time: Time.now + 1.hour)
    assert_not training_activity.save, "Saved the training activity without a start time"
  end

  test "should not save training activity without end time" do
    training_activity = TrainingActivity.new(title: "Example", activity_type: "Workshop", start_time: Time.now)
    assert_not training_activity.save, "Saved the training activity without an end time"
  end

  test "end time should not be before start time" do
    training_activity = TrainingActivity.new(title: "Example", activity_type: "Workshop", start_time: Time.now, end_time: Time.now - 1.hour)
    assert_not training_activity.valid?, "Training activity should not be valid with end time before start time"
    assert_includes training_activity.errors.messages[:end_time], "must be after the start time"
  end

  test "should save valid training activity" do
    training_activity = TrainingActivity.new(title: "Example", activity_type: "Workshop", start_time: Time.now, end_time: Time.now + 1.hour)
    assert training_activity.save, "Could not save valid training activity"
  end

  test "should set default status to Pending on create" do
    training_activity = TrainingActivity.new(title: "Example", activity_type: "Workshop", start_time: Time.now, end_time: Time.now + 1.hour)
    training_activity.save
    assert_equal "Pending", training_activity.status
  end
end
