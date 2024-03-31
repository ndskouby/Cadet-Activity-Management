# spec/helpers/application_helper_spec.rb
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#custom_error_messages_for' do
    it 'returns error messages without attribute names' do
      object = double('Object')
      allow(object).to receive_message_chain(:errors, :full_messages)
        .and_return(['Name can\'t be blank', 'Email is invalid'])

    end
  end

  describe '#badge_color_for_status' do
    it 'returns bg-warning for pending status' do
      expect(badge_color_for_status('Pending Approval')).to eq('bg-warning')
    end

    it 'returns bg-success for approved status' do
      expect(badge_color_for_status('Approved')).to eq('bg-success')
    end

    it 'returns bg-danger for rejected status' do
      expect(badge_color_for_status('Rejected')).to eq('bg-danger')
    end

    it 'returns bg-info for revision status' do
      expect(badge_color_for_status('Under Revision')).to eq('bg-info')
    end

    it 'returns bg-light text-dark for unknown status' do
      expect(badge_color_for_status('Unknown')).to eq('bg-light text-dark')
    end
  end
end

