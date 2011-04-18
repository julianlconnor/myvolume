class Artist < ActiveRecord::Base
  has_many :memberships
  has_many :songs, :through => :memberships
  
  has_one :artist_thumbnail
  
end
