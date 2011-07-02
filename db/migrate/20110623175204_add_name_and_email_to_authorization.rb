class AddNameAndEmailToAuthorization < ActiveRecord::Migration
  def self.up
    add_column :authorization, :email, :string
    add_column :authorization, :name, :string
  end

  def self.down
    remove_column :authorization, :email
    remove_column :authorization, :name
  end
end
