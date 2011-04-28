class CreateTopDownloads < ActiveRecord::Migration
  def self.up
    create_table (:top_downloads, :primary_key => :rank) do |t|
      t.integer :rank
      t.references :song
      t.integer :difference
    end
  end

  def self.down
    drop_table :top_downloads
  end
end
