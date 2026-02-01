class CoordinatesController < ApplicationController
  def index
    answer_log = current_user.answer_logs.order(created_at: :desc).first
    if answer_log.nil?
      redirect_to new_question_path, alert: "質問ページから回答の登録を行ってください"
      return
    end
    selected_option_ids = answer_log.answers.pluck(:option_id)
    @coordinates = Coordinate.search_by_options(selected_option_ids)
  end
end
