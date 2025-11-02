class AddressStat < ApplicationRecord
  belongs_to :address

  validates :confirmed_sats, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :unconfirmed_sats, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :tx_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end


