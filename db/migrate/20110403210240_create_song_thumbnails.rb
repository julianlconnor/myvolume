class CreateSongThumbnails < ActiveRecord::Migration
  def self.up
    create_table :song_thumbnails do |t|
      t.references :song, :unique => true
      t.string :small
      t.string :medium
      t.string :large
      t.timestamps
    end
  end

  def self.down
    drop_table :song_thumbnails
  end
end
