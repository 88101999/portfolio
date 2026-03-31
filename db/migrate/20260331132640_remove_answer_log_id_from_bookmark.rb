class RemoveAnswerLogIdFromBookmark < ActiveRecord::Migration[7.2]
  def change
    remove_reference :bookmarks, :answer_log, null: false, foreign_key: true
  end
end
