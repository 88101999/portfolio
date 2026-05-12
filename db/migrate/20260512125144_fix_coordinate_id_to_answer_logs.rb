class FixCoordinateIdToAnswerLogs < ActiveRecord::Migration[7.2]
  def change
    add_column :answer_logs, :coordinate_id, :bigint
    add_index :answer_logs, :coordinate_id
    add_foreign_key :answer_logs, :coordinates
  end
end
