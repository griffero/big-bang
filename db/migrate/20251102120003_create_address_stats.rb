class CreateAddressStats < ActiveRecord::Migration[8.0]
  def change
    create_table :address_stats do |t|
      t.references :address, null: false, foreign_key: true
      t.bigint :confirmed_sats, default: 0, null: false
      t.bigint :unconfirmed_sats, default: 0, null: false
      t.integer :tx_count, default: 0, null: false
      t.datetime :first_seen_at
      t.datetime :last_seen_at
      t.string :source
      t.jsonb :raw_json

      t.timestamps
    end
  end
end


