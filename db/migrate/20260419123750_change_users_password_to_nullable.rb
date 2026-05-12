class ChangeUsersPasswordToNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :crypted_password, true
    change_column_null :users, :salt, true
  end
end
