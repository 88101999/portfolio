class AddAiExplanationToCoordinates < ActiveRecord::Migration[7.2]
  def change
    add_column :coordinates, :ai_explanation, :text
  end
end
