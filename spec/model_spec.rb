# frozen_string_literal: true

require 'rails_helper'

require 'shoulda/matchers'
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.describe Unit, type: :model do
  describe 'associations' do
    it { should belong_to(:parent).optional.with_foreign_key(:parent_id).class_name('Unit') }
  end

  describe '#children' do
    let(:parent_unit) { create(:unit) }
    let!(:child_units) { create_list(:unit, 3, parent: parent_unit) }

    it 'returns the children units of the parent unit' do
      expect(parent_unit.children).to match_array(child_units)
    end
  end
end
