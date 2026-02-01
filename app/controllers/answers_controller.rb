class AnswersController < ApplicationController
  def create
    params.select { |k, _| k.to_s.start_with?("question_") }.each do |key, option_id|
      question_id = key.split("_").last.to_i
        Answer.create!(
          user_id: current_user.id,
          question_id: question_id,
          option_id: option_id,
          answer_log_id: nil
        )
    end
    redirect_to coordinates_path
  end
end
