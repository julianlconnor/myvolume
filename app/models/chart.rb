class Chart < ActiveRecord::Base
  has_many :chart_memberships
  has_many :songs, :through => :chart_memberships
  has_one :chart_thumbnail
end
