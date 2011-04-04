class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :name
      t.string :mix_name
      t.string :artist
      t.string :remixer

      t.references :label
      
      t.string :sample_url
      t.string :length
      
      t.integer :beatport_id, :unique => true
      
      t.datetime :release_date
      t.datetime :publish_date
      
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
