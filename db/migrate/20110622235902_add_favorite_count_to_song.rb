class AddFavoriteCountToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :favorite_count, :integer, :default => 0
  end

  def self.down
    remove_column :songs, :favorite_count
  end
end
