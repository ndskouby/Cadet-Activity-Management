# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

COMPETENCIES = [
  'Respect and Inclusion',
  'Resilience',
  'Financial Literacy',
  'Ethical Leadership',
  'Technology',
  'Physical and Mental Wellness',
  'Adaptability',
  'Professionalism',
  'Communication',
  'Career and Self Development',
  'Teamwork',
  'Critical Thinking'
].freeze

COMPETENCIES.each do |competency|
  Competency.find_or_create_by(name: competency)
end

major = Unit.create(name: 'Unassigned Major', cat: 'major', email: 'no_email')
minor = Unit.create(name: 'Unassigned Minor', cat: 'minor', email: 'no_email', parent: major)
Unit.create(name: 'Unassigned Outfit', cat: 'outfit', email: 'no_email', parent: minor)

IngestRosterFile.new.ingest_roster_file('lib/assets/devroster.csv')
