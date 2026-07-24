class CoordinateRecommendationService
  class RateLimitExceededError < StandardError; end

  MAX_REQUESTS_PER_DAY = 5
  def initialize(user_answers, coordinate, ip_address)
    @user_answers = user_answers
    @coordinate = coordinate
    @ip_address = ip_address || "unknown"
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
    date = Time.current.in_time_zone("Asia/Tokyo").strftime("%Y-%m-%d")
    "rate_limit:#{@ip_address}:#{date}"
  end

  # 午前0時までの秒数を計算
  def seconds_until_midnight
    now = Time.current.in_time_zone("Asia/Tokyo")
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
        role: "system",
        content: "あなたはファッションコーディネートの専門家です。"
      },
      {
        role: "user",
        content:  build_prompt(coordinate_info)
      }
    ]
  end

def build_prompt(coordinate_info)
  <<~PROMPT
    あなたは現役のファッションスタイリストです。ユーザーが選択した条件に合うコーデについて解説してください。以下の形式で出力してください。

    【ユーザーの回答】
    #{@user_answers}

    【提案されたコーディネート】
    #{coordinate_info}

    以下の形式で出力してください。

    【このコーデのポイント】
    コーディネート名や説明文をそのまま繰り返さず、ユーザーにとって役立つ情報を補足してください。
    必ず「・」を使った箇条書きで3項目以内にしてください。
    ・3つ以内

    【おすすめのシーン】
    ユーザーが選択した利用シーンを踏まえて説明してください。
    80文字以内

    【着こなしのコツ】
    文章は専門用語を使いすぎず、20〜30代向けの親しみやすい文章にしてください。
    春だから〜など一般論は書かず、提案したコーデそのものについて解説してください。
    親しいショップ店員が話しかけるような自然で親しみやすい口調で回答してください。
    300文字以内。
  PROMPT
end
  def parse_response(response)
    response.dig("choices", 0, "message", "content")
  end
end
