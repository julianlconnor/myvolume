class Chart < ActiveRecord::Base
  has_many :chart_memberships
  has_many :songs, :through => :chart_memberships
  
  has_many :chart_genre_memberships
  has_many :genres, :through => :chart_genre_memberships
  
  has_one :chart_thumbnail
  
  self.per_page = 5
  
end
