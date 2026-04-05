class AddCoordinateIdToAnswerLogs < ActiveRecord::Migration[7.2]
  def change
    add_column :answer_logs, :coordinate_id, :integer
  end
end
