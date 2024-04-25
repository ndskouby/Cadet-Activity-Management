# frozen_string_literal: true

Then('an email should be sent to {string}') do |email|
  user_id = ActiveJob::Base.queue_adapter.enqueued_jobs.last[:args][3]['args'][1]['_aj_globalid'].split('/').last
  expect(User.find(user_id).email).to eq(email)
end

Then('an email should not be sent to {string}') do |email|
  user_id = ActiveJob::Base.queue_adapter.enqueued_jobs.last[:args][3]['args'][1]['_aj_globalid'].split('/').last
  expect(User.find(user_id).email).to_not eq(email)
end
