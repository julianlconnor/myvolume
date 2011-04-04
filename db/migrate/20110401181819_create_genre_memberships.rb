class CreateGenreMemberships < ActiveRecord::Migration
  def self.up
      create_table :genre_memberships do |t|
        t.references :genre
        t.references :song
        t.timestamps
      end
    end

    def self.down
      drop_table :genre_memberships
    end
end
