class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :username
    end

    add_index :users, :email,                :unique => true
  end

  def self.down
    drop_table :users
  end
end
