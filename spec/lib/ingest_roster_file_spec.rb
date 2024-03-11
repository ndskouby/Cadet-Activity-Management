# frozen_string_literal: true

require 'rails_helper'
require_relative  '../../lib/ingest_roster_file'

RSpec.feature "Roster Ingestor" do

  describe 'Load File' do
    it 'loads units correctly' do
        ingest_roster_file("spec/support/fixtures/demoCorpsRoster.csv")
        user = User.find_by!(email: "dummy_email_4@tamu.edu")
        expect(user.unit.name).to eq("B2")
        expect(user.unit.parent.name).to eq("3BN")
        expect(user.unit.parent.parent.name).to eq("1BDE")
    end
  end

end
