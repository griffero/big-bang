class Address < ApplicationRecord
  belongs_to :phrase
  has_one :address_stat, dependent: :destroy

  enum :variant, { compressed: 0, uncompressed: 1 }

  validates :address, presence: true, uniqueness: true
  validates :variant, presence: true
end


