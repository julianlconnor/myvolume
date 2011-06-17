class Song < ActiveRecord::Base
  has_many :memberships
  has_many :artists, :through => :memberships
  
  has_many :chart_memberships
  has_many :charts, :through => :chart_memberships
  
  has_many :genre_memberships
  has_many :genres, :through => :genre_memberships
  
  has_many :favorites
  has_many :users, :through => :Favorites
  
  has_one :song_thumbnail
  belongs_to :label
  
  has_one :top_download
  
  
end
