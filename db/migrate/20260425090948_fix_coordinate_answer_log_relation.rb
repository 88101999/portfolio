class FixCoordinateAnswerLogRelation < ActiveRecord::Migration[7.2]
  def change
    # answer_logs テーブルから coordinate_id を削除
    remove_column :answer_logs, :coordinate_id, :integer

    # coordinates テーブルに answer_log_id を追加
    add_reference :coordinates, :answer_log, foreign_key: true
  end
end