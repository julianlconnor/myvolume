class CreateSubGenres < ActiveRecord::Migration
  def self.up
    create_table :sub_genres do |t|
        t.integer :genre_id
        t.string :name, :unique => true
        t.string :slug
        t.timestamps
      end
  end

  def self.down
    drop_table :sub_genres
  end
end
