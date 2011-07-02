class AddRoleIdToUsersAndAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :users, :role_id, :integer, :default => 2
    add_column :authorizations, :role_id, :integer, :default => 2
  end

  def self.down
    remove_column :users, :role_id
    remove_column :authorizations, :role_id
  end
end
