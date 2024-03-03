FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@tamu.edu" }
    sequence(:first_name) { |n| "Test#{n}" }
    last_name { 'User' }
    uid { SecureRandom.random_number(1_000_000_000).to_s }
    provider { 'google_oauth2' }
  end
end
