# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Roster Ingestor' do
  describe 'Load File' do
    it 'loads units correctly' do
      IngestRosterFile.new.ingest_roster_file('spec/support/fixtures/demoCorpsRoster.csv')
      user = User.find_by!(email: 'c@a.com')
      expect(user.unit.name).to eq('K1')
      expect(user.unit.parent.name).to eq('2BN')
      expect(user.unit.parent.parent.name).to eq('1BDE')
      expect(user.units).to match_array([Unit.find_by(name: 'K1'), Unit.find_by(name: '2BN'), Unit.find_by(name: '1BDE'), Unit.find_by(name: 'CMDT Staff')])
    end

    it 'does not duplicate users' do
      errors = IngestRosterFile.new.ingest_roster_file('spec/fixtures/files/demoCorpsRoster.csv')
      expect(errors).not_to be_empty
    end
  end
end
