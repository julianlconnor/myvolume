class CreateAuthorizationFavorites < ActiveRecord::Migration
  def self.up
    create_table :authorization_favorites do |t|
      t.references :authorization
      t.references :song
      t.timestamps
    end
  end

  def self.down
    drop_table :authorization_favorites
  end
end
