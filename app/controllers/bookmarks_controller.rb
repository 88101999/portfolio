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

    @bookmark = current_user.bookmarks.build(coordinate: @coordinate)

    if @bookmark.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: coordinates_path, notice: "お気に入りに追加しました" }
      end
    else
      redirect_back fallback_location: coordinates_path, alert: "お気に入りに追加できませんでした"
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @coordinate = @bookmark.coordinate
    @bookmark.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: coordinates_path, notice: "お気に入りから削除しました" }
    end
  end
end
