class AddSorceryToUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :password_digest
    add_column :users, :crypted_password, :string, null: false
    add_column :users, :salt, :string, null: false
  end
end
