class Genre < ActiveRecord::Base
  has_many :genre_memberships
  has_many :songs, :through => :genre_memberships
  
  has_many :sub_genres
end
