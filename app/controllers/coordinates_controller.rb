class CoordinatesController < ApplicationController
  def index
    @answer_log = current_user.answer_logs.order(created_at: :desc).first
    if @answer_log.nil?
      redirect_to new_question_path, alert: "質問ページから回答の登録を行ってください"
      return
    end
    selected_option_ids = @answer_log.answers.pluck(:option_id)
    @coordinates = Coordinate.search_by_options(selected_option_ids)

    if @answer_log.ai_explanation.blank? && @coordinates.present?
      begin
        user_answers = format_user_answers(@answer_log)
        coordinate = @coordinates.first

        service = CoordinateRecommendationService.new(user_answers, coordinate, request.remote_ip)

        @answer_log.ai_explanation = service.call
        @answer_log.save!

      rescue CoordinateRecommendationService::RateLimitExceededError => e
        @ai_explanation_error = e.message
      rescue StandardError => e
        Rails.logger.error("Ai explanation error: #{e.message}")
        @ai_explanation_error = "AIによる説明の生成に失敗しました。"
      end
    end
  end
  
  private
  
  def format_user_answers(answer_log)
    answer_log.answers.includes(:question, :option).map do |answer|
      "#{answer.question.text}: #{answer.option.name}"
    end.join("\n")
  end
end
