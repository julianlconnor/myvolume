class AddRankToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :rank, :integer
  end

  def self.down
    remove_column :songs, :rank
  end
end
