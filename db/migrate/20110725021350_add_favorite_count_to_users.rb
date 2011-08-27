class AddFavoriteCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :favorite_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :favorite_count
  end
end
