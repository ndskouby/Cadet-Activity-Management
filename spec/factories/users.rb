# frozen_string_literal: true

FactoryBot.define do

  factory :unit do
    name { 'Dummy Unit' }
    cat { 'generic' }
    email { 'dummy_unit_email@email.email' }
    parent_id { nil }
  end

  factory :user do
    email { "user#{SecureRandom.random_number(1_000_000)}@tamu.edu" }
    first_name { "Test#{SecureRandom.hex(4)}" }
    last_name { 'User' }
    uid { SecureRandom.random_number(1_000_000_000).to_s }
    provider { 'google_oauth2' }
    unit_id { FactoryBot.create(:unit).id }
  end
end
