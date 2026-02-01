class AddDescriptionAndImageUrlToCoordinates < ActiveRecord::Migration[7.2]
  def change
    add_column :coordinates, :description, :text
    add_column :coordinates, :image_url, :string
  end
end
