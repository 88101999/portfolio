class RemoveOmniauthFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
