class CreateCharts < ActiveRecord::Migration
  def self.up
    create_table :charts do |t|
      t.string :name
      t.integer :beatport_id
      t.text :description
      t.datetime :publish_date
      t.timestamps
    end
  end

  def self.down
    drop_table :charts
  end
end
