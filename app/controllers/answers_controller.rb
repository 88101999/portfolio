class AnswersController < ApplicationController
  def create
    answer_log = AnswerLog.create!(user_id: current_user.id)
    params.select { |k, _| k.to_s.start_with?("question_") }.each do |key, option_id|
      question_id = key.split("_").last.to_i
        Answer.create!(
          user_id: current_user.id,
          question_id: question_id,
          option_id: option_id,
          answer_log_id: answer_log.id
        )
    end
    redirect_to coordinates_path
  end
end
