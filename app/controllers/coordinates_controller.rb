class CoordinatesController < ApplicationController
  before_action :require_login

  def index
    @answer_log = current_user.answer_logs.order(created_at: :desc).first

    if @answer_log.nil?
      redirect_to step_diagnoses_path(step: 1), alert: "質問ページから回答の登録を行ってください"
      return
    end

    selected_option_ids = @answer_log.answers.pluck(:option_id)
    @coordinates = Coordinate.search_by_options(selected_option_ids)

    if @coordinates.blank?
      redirect_to step_diagnoses_path(step: 1), alert: "該当するコーディネートが見つかりませんでした"
      return
    end

    user_answers = format_user_answers(@answer_log)
    ip_address = get_real_client_ip

    @coordinates.each do |coordinate|
      if coordinate.ai_explanation.blank?
        begin
          service = CoordinateRecommendationService.new(user_answers, coordinate, ip_address)
          coordinate.ai_explanation = service.call
          coordinate.save!
        rescue CoordinateRecommendationService::RateLimitExceededError => e
          coordinate.ai_explanation_error = e.message
          coordinate.save!
        rescue StandardError => e
          Rails.logger.error("AI explanation error for coordinate #{coordinate.id}: #{e.message}")
          coordinate.ai_explanation_error = "AIによる説明の生成に失敗しました。"
          coordinate.save!
        end
      end
    end
  end

  def show
    @coordinate = Coordinate.find(params[:id])
    @answer_log = current_user.answer_logs.order(created_at: :desc).first
    @ai_explanation_error = nil

    if @coordinate.ai_explanation.blank?
      @ai_explanation_error = "このコーディネートのAI解説は、コーディネート提案ページからご覧いただけます。"
    end
  end

  private

  def format_user_answers(answer_log)
    answer_log.answers.includes(:question, :option).map do |answer|
      "#{answer.question.text}: #{answer.option.name}"
    end.join("\n")
  end

  # 実際のクライアントIPを取得
  def get_real_client_ip
    # Cloudflareを使用している場合は CF-Connecting-IP を優先
    cloudflare_ip = request.headers["CF-Connecting-IP"]
    return cloudflare_ip if cloudflare_ip.present?

    # それ以外のプロキシの場合は X-Forwarded-For から取得
    forwarded_for = request.headers["X-Forwarded-For"]
    if forwarded_for.present?
      # カンマ区切りの場合は最初のIPを使用（実際のクライアントIP）
      forwarded_for.split(",").first.strip
    else
      # フォールバック
      request.remote_ip || request.ip || "unknown"
    end
  end
end
