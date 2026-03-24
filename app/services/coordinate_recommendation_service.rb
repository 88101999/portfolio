class CoordinateRecommendationService
  class RateLimitExceededError < StandardError; end

  MAX_REQUESTS_PER_DAY = 5
  def initialize(user_answers, coordinate, ip_address)
    @user_answers = user_answers
    @coordinate = coordinate
    @ip_address = ip_address
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def call
    check_rate_limit!
     
    begin
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: build_messages,
          temperature: 0.7
        }
      )

      increment_rate_limit_counter

      parse_response(response)
    rescue Faraday::TooManyRequestsError => e
      handle_openai_rate_limit_error(e)
    rescue StandardError => e
      Rails.logger.error("OpenAI API error: #{e.message}")
      raise
    end
  end

  private

  # レート制限のチェック
  def check_rate_limit!
    current_count = get_current_request_count

    if current_count >= MAX_REQUESTS_PER_DAY
      raise RateLimitExceededError, "本日のAI解説は上限  (#{MAX_REQUESTS_PER_DAY}回) に達しました。診断結果はご覧いただけますので、明日の午前0時以降に改めてAI解説をお試しください。"
    end
  end

  # 現在のリクエスト回数を取得
  def get_current_request_count
    REDIS_CLIENT.get(rate_limit_key).to_i
  end

  # リクエスト回数を増加
  def increment_rate_limit_counter
    current_count = get_current_request_count

    if current_count.zero?
      REDIS_CLIENT.setex(rate_limit_key, seconds_until_midnight, 1) # 初回リクエストでカウンターをセットし、有効期限を翌日の午前0時までに設定
    else
      REDIS_CLIENT.incr(rate_limit_key) # 2回目以降はカウンターを増加
    end
  end

  # REDISのキーを生成(IPアドレス+日付)
  def rate_limit_key
    date = Time.current.in_time_zone('Asia/Tokyo').strftime('%Y-%m-%d')
    "rate_limit:#{@ip_address}:#{date}"
  end

  # 午前0時までの秒数を計算
  def seconds_until_midnight
    now = Time.current.in_time_zone('Asia/Tokyo')
    midnight = now.tomorrow.beginning_of_day
    (midnight - now).to_i
  end

  # OpenAIのレート制限エラーを処理
  def handle_openai_rate_limit_error(error)
    Rails.logger.error("OpenAI Rate Limit Error: #{error.message}")
    raise RateLimitExceededError, "OpenAIのレート制限に達しました。しばらくしてから再度お試しください。"
  end

  def build_messages
    coordinate_info = "#{@coordinate.name}\n#{@coordinate.description}"
    [
      {
        role: 'system',
        content: 'あなたはファッションコーディネートの専門家です。'
      },
      {
        role: 'user',
        content:  build_prompt(coordinate_info)
      }
    ]
  end

def build_prompt(coordinate_info)
  <<~PROMPT
    以下のユーザーの回答と提案されたコーディネートに基づいて、このコーディネートが適している理由を説明してください。

    【ユーザーの回答】
    #{@user_answers}

    【提案されたコーディネート】
    #{coordinate_info}

    【条件】
    - 180〜220文字程度
    - 前向きで親しみやすい内容
    - 理由がわかりやすい説明にする
    - ユーザーの回答内容に必ず触れる
    - 季節・利用シーン・好みのスタイルと、コーディネートの要素がどう合っているかを具体的に書く
    - ファッション初心者にもわかるやさしい表現にする
    - 最後は「取り入れやすい」「挑戦しやすい」など前向きに締める
    - 箇条書きは禁止
  PROMPT
end
  def parse_response(response)
    response.dig('choices', 0, 'message', 'content')
  end
end