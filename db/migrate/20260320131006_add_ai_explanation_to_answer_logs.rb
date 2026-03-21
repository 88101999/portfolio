class AddAiExplanationToAnswerLogs < ActiveRecord::Migration[7.2]
  def change
    add_column :answer_logs, :ai_explanation, :text
  end
end
