# frozen_string_literal: true

class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :provider, presence: true
end
