class AddFavoriteCountToAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :favorite_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :authorizations, :favorite_count
  end
end
