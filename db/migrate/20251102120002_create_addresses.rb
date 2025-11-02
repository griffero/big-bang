class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :phrase, null: false, foreign_key: true
      t.integer :variant, null: false, default: 0
      t.string :address, null: false
      t.string :wif
      t.string :hash160

      t.timestamps
    end

    add_index :addresses, :address, unique: true
  end
end


