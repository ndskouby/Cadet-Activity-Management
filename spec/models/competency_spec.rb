# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competency, type: :model do
  it 'has a valid factory' do
    expect(build(:competency)).to be_valid
  end
end
