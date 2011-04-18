class CreateChartGenreMemberships < ActiveRecord::Migration
  def self.up
    create_table :chart_genre_memberships do |t|
      t.references :genre
      t.references :chart
    end
  end

  def self.down
    drop_table :chart_genre_memberships
  end
end
