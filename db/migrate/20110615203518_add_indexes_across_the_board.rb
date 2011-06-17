class AddIndexesAcrossTheBoard < ActiveRecord::Migration
  def self.up
    add_index :users, :email
    add_index :artists, :id
    add_index :authorizations, :uid
    
    add_index :chart_genre_memberships, :chart_id
    add_index :chart_genre_memberships, :genre_id
    
    add_index :chart_memberships, :song_id
    add_index :chart_memberships, :chart_id
    
    add_index :genre_memberships, :genre_id
    add_index :genre_memberships, :song_id
    
    add_index :memberships, :artist_id
    add_index :memberships, :song_id
    
    add_index :chart_thumbnails, :chart_id
    add_index :artist_thumbnails, :artist_id
    add_index :song_thumbnails, :song_id
    
    add_index :sub_genres, :genre_id
    
    add_index :top_downloads, :song_id
  end

  def self.down
    remove_index :users, :email
    remove_index :artists, :id
    remove_index :authorizations, :uid
    
    remove_index :chart_genre_memberships, :chart_id
    remove_index :chart_genre_memberships, :genre_id
    
    remove_index :chart_memberships, :song_id
    remove_index :chart_memberships, :chart_id
    
    remove_index :genre_memberships, :genre_id
    remove_index :genre_memberships, :song_id
    
    remove_index :memberships, :artist_id
    remove_index :memberships, :song_id
    
    remove_index :chart_thumbnails, :chart_id
    remove_index :artist_thumbnails, :artist_id
    remove_index :song_thumbnails, :song_id
    
    remove_index :sub_genres, :genre_id
    
    remove_index :top_downloads, :song_id
  end
end
