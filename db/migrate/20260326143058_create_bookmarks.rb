class CreateBookmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coordinate, null: false, foreign_key: true
      t.references :answer_log, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bookmarks, [:user_id, :coordinate_id, :answer_log_id], unique: true, name: 'index_bookmarks_on_user_coordinate_answer_log'
  end
end
