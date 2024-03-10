# frozen_string_literal: true

FactoryBot.define do
  factory :training_activity do
    name { 'Sample Activity' }
    date { Date.today }
    time { 'MA' }
    location { 'Kyle Ramps' }
    priority do
      ['Leaders of Character', 'Resiliency Training', 'Military Training', 'Career Readiness',
       'Physical Fitness'].sample
    end
    justification { 'Required for development...' }
    status { "pending_minor_unit_approval" }
    user_id { FactoryBot.create(:user).id }

    after(:build) do |training_activity|
      competencies = Competency.where(name: ['Respect and Inclusion', 'Resilience']).pluck(:id)
      training_activity.competency_ids = competencies if competencies.present?

      training_activity.opord_upload.attach(
        io: File.open(Rails.root.join('spec', 'support', 'fixtures', 'sample_opord.pdf')),
        filename: 'sample_opord.pdf',
        content_type: 'application/pdf'
      )
    end
  end
end
