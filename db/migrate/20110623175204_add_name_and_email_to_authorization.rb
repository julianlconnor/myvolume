class AddNameAndEmailToAuthorization < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :email, :string
    add_column :authorizations, :name, :string
  end

  def self.down
    remove_column :authorizations, :email
    remove_column :authorizations, :name
  end
end
