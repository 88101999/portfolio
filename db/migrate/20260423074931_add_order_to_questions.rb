class AddOrderToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :order, :integer, null: false
    add_index :questions, :order
  end
end
