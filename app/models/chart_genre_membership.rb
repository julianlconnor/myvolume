class ChartGenreMembership < ActiveRecord::Base
  belongs_to :chart
  belongs_to :genre
end
