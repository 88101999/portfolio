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
      @answer_log.ai_explanation = generate_explanation(@answer_log, @coordinates.first)
      @answer_log.save!
  end
end

private

def generate_explanation(answer_log, coordinate)
  user_answers = answer_log.answers.includes(:question, :option).map do |answer|
    "#{answer.question.text}: #{answer.option.name}"
  end.join("\n")

  coordinate_info = "#{coordinate.name}\n#{coordinate.description}"

  prompt = <<~PROMPT
    あなたはファッションコーディネートの専門家です。以下のユーザーの回答に基づいて、最も適したコーディネートを選び、その理由を説明してください。
    【ユーザーの回答】
    #{user_answers}

    【提案するコーディネート】
    #{coordinate_info}

    【条件】
     - 200文字程度で説明してください
     - 親しみやすく、前向きな口調で書いてください
     - ユーザーの回答内容に触れながら、このコーディネートが適している理由を箇条書きで説明してください
     - 「あなた」という表現を使って、ユーザーに直接語りかけるようにしてください
  PROMPT

  begin
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7, 
      }
    )

    response.dig("choices", 0, "message", "content")
    rescue => e
      Rails.logger.error("OpenAI API error: #{e.message}")
      "このコーディネートは、あなたの回答内容に基づいておすすめしています。"
    end
  end
end
