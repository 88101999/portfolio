module BookmarksHelper
  def bookmarked?(coordinate)
    @bookmarked_coordinate_ids ||= current_user.bookmarked_coordinates.pluck(:id)
    @bookmarked_coordinate_ids.include?(coordinate.id)
  end

  def find_bookmark(coordinate)
    @bookmarks_hash ||= current_user.bookmarks.index_by(&:coordinate_id)
    @bookmarks_hash[coordinate.id]
  end
end