ActiveAdmin.register Address do
  actions :all

  includes :phrase, :address_stat

  index do
    selectable_column
    id_column
    column :address
    column :variant
    column(:phrase) { |a| a.phrase&.content }
    column(:confirmed_sats) { |a| a.address_stat&.confirmed_sats }
    column(:unconfirmed_sats) { |a| a.address_stat&.unconfirmed_sats }
    column(:tx_count) { |a| a.address_stat&.tx_count }
    actions
  end

  filter :address
  filter :variant
  filter :phrase_content_cont, as: :string, label: 'Phrase contains'

  show do
    attributes_table do
      row :address
      row :variant
      row(:phrase) { |a| a.phrase&.content }
      row(:hash160)
      row(:wif) { |a| a.wif.present? ? a.wif : '(hidden)' }
      row(:confirmed_sats) { |a| a.address_stat&.confirmed_sats }
      row(:unconfirmed_sats) { |a| a.address_stat&.unconfirmed_sats }
      row(:tx_count) { |a| a.address_stat&.tx_count }
      row(:raw_json) { |a| pre a.address_stat&.raw_json&.to_json }
    end
  end
end


