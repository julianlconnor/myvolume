class CreateArtistThumbnails < ActiveRecord::Migration
  def self.up
    create_table :artist_thumbnails do |t|
      t.references :artist, :unique => true
      t.string :small
      t.string :medium
      t.string :large
      t.timestamps
    end
  end

  def self.down
    drop_table :artist_thumbnails
  end
end
