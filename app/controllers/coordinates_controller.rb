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

        # 修正：実際のクライアントIPを取得
        ip_address = get_real_client_ip
        
        Rails.logger.info("=== IP Address Debug ===")
        Rails.logger.info("IP Address: #{ip_address}")
        Rails.logger.info("X-Forwarded-For: #{request.headers['X-Forwarded-For']}")
        Rails.logger.info("CF-Connecting-IP: #{request.headers['CF-Connecting-IP']}")
        
        service = CoordinateRecommendationService.new(user_answers, coordinate, ip_address)

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
  
  # 実際のクライアントIPを取得
  def get_real_client_ip
    # Cloudflareを使用している場合は CF-Connecting-IP を優先
    cloudflare_ip = request.headers['CF-Connecting-IP']
    return cloudflare_ip if cloudflare_ip.present?
    
    # それ以外のプロキシの場合は X-Forwarded-For から取得
    forwarded_for = request.headers['X-Forwarded-For']
    if forwarded_for.present?
      # カンマ区切りの場合は最初のIPを使用（実際のクライアントIP）
      forwarded_for.split(',').first.strip
    else
      # フォールバック
      request.remote_ip || request.ip || 'unknown'
    end
  end
end
