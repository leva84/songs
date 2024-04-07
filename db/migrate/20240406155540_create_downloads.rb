class CreateDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :downloads do |t|
      t.references :song, null: false, foreign_key: true
      t.integer :count, null: false, default: 0
      t.date :download_date, null: false

      t.timestamps
    end

    add_index :downloads, [:song_id, :download_date], unique: true
  end
end
