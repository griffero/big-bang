class CreatePhrases < ActiveRecord::Migration[8.0]
  def change
    create_table :phrases do |t|
      t.string :content, null: false
      t.integer :status, null: false, default: 0
      t.datetime :last_scanned_at

      t.timestamps
    end

    add_index :phrases, :content, unique: true
  end
end


