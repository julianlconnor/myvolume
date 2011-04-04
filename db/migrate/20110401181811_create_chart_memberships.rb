class CreateChartMemberships < ActiveRecord::Migration
  def self.up
      create_table :chart_memberships do |t|
        t.references :song
        t.references :chart
        t.integer :pos
        t.timestamps
      end
    end

  def self.down
    drop_table :chart_memberships
  end
end
