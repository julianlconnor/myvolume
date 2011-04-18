class CreateCronWatchers < ActiveRecord::Migration
  def self.up
    create_table :cron_watchers do |t|
      t.datetime :last_update
    end
  end

  def self.down
    drop_table :cron_watchers
  end
end
