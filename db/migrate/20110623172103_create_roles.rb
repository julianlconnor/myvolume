class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    r = Role.new(:name => "admin")
    r.save
    r = Role.new(:name => "user")
    r.save
  end

  def self.down
    drop_table :roles
  end
end
