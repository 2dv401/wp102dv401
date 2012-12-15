class AddDeviseTwitterFieldsToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.column :twitter_handle, :string
      t.column :twitter_oauth_token, :string
      t.column :twitter_oauth_secret, :string
    end

    add_index :users, :twitter_handle, :unique => true
    add_index :users, [:twitter_oauth_token, :twitter_oauth_secret]
  end

  def self.down
    remove_index :users, :column => :twitter_handle
    remove_index :users, :column => [:twitter_oauth_token, :twitter_oauth_secret]

    change_table(:users) do |t|
      t.remove :twitter_handle, :string
      t.remove :twitter_oauth_token, :string
      t.remove :twitter_oauth_secret, :string
    end
  end
end
