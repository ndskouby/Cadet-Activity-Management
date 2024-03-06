class User < ApplicationRecord
  belongs_to :minor_unit
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :provider, presence: true
end
