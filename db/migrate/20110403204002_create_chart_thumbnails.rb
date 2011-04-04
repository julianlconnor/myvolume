class CreateChartThumbnails < ActiveRecord::Migration
  def self.up
    create_table :chart_thumbnails do |t|
      t.references :chart, :unique => true
      t.string :small
      t.string :medium
      t.string :large
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_thumbnails
  end
end
