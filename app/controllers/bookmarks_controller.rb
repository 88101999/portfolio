class BookmarksController < ApplicationController
  before_action :require_login
  def index
    @bookmarks = current_user.bookmarks.includes(:coordinate).order(created_at: :desc)
  end

  def create
    @coordinate = Coordinate.find(params[:coordinate_id])

    if current_user.bookmarks.exists?(coordinate: @coordinate)
      redirect_to coordinates_path, alert: "このコーディネートは既にお気に入りに追加されています"
      return
    end

    current_user.bookmarks.create(coordinate: @coordinate)
    redirect_to coordinates_path, notice: "お気に入りに追加しました"
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    coordinate = @bookmark.coordinate
    current_user.unbookmark(coordinate)
    redirect_to bookmarks_path, notice: "お気に入りから削除しました"
  end
end
