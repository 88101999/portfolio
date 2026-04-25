class AddAiExplanationErrorToCoordinates < ActiveRecord::Migration[7.2]
  def change
    add_column :coordinates, :ai_explanation_error, :text
  end
end
