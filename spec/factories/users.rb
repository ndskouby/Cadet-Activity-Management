# frozen_string_literal: true

FactoryBot.define do
  factory :commandant do
    name { 'Dummy Commandant' }
    email { 'dummy_commandant@tamu.edu ' }
  end

  factory :major_unit do
    name { 'Dummy Major Unit' }
    email { 'dummy_major_unit@tamu.edu' }
    commandant_id { FactoryBot.create(:commandant).id }
  end

  factory :minor_unit do
    name { 'Dummy Minor Unit' }
    email { 'dummy_minor_unit@tamu.edu' }
    major_unit_id { FactoryBot.create(:major_unit).id }
  end

  factory :user do
    email { "user#{SecureRandom.random_number(1_000_000)}@tamu.edu" }
    first_name { "Test#{SecureRandom.hex(4)}" }
    last_name { 'User' }
    uid { SecureRandom.random_number(1_000_000_000).to_s }
    provider { 'google_oauth2' }
    minor_unit_id { FactoryBot.create(:minor_unit).id }
  end
end
