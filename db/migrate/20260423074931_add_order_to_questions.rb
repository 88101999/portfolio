class AddOrderToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :order, :integer, default: 0, null: false
    
    reversible do |dir|
      dir.up do
        Question.reset_column_information
        Question.find_each.with_index(1) do |question, index|
          question.update_column(:order, index)
        end
      end
    end
    
    change_column_default :questions, :order, from: 0, to: nil
  end
end