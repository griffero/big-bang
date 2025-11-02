ActiveAdmin.register AddressStat do
  actions :all
  includes :address

  index do
    selectable_column
    id_column
    column(:address) { |s| s.address&.address }
    column :confirmed_sats
    column :unconfirmed_sats
    column :tx_count
    column :last_seen_at
    column :source
    actions
  end

  filter :address_address_cont, as: :string, label: 'Address contains'
  filter :confirmed_sats
  filter :tx_count
  filter :source
  filter :last_seen_at
end


