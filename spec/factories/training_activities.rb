FactoryBot.define do
  factory :training_activity do
    sequence(:title) { |n| "training_event_#{n}" }
    status { "Pending"}
    activity_type { "Military"}
    start_time { Time.new(2024, 2, 1, 12, 0, 0)}
    end_time { Time.new(2024, 2, 5, 12, 0, 0)}
  end
end

# spec/factories/training_activity_status_logs.rb
FactoryBot.define do
  factory :training_activity_status_log do
    association :training_activity
    status { "Pending" }
    updated_by { "User_Name" }
  end
end
