class CreateCoordinateOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :coordinate_options do |t|
      t.references :coordinate, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end

    add_index :coordinate_options, [:coordinate_id, :option_id], unique: true
  end
end
