class DiagnosesController < ApplicationController
  before_action :initialize_session, only: [ :show_step, :update_step ]

  # 各ステップの表示
  def show_step
    @step = params[:step].to_i
    @question = Question.find_by!(order: @step)
    @current_answer = session[:diagnosis_answers][@step.to_s]
  end

  # 各ステップの回答を受け取る
  def update_step
    @step = params[:step].to_i
    option_id = params[:option_id]

    if option_id.blank?
      redirect_to step_diagnoses_path(step: @step), alert: "選択肢を選んでください"
      return
    end

    session[:diagnosis_answers][@step.to_s] = option_id

    total_steps = Question.count

    if @step < total_steps
      redirect_to step_diagnoses_path(step: @step + 1), status: :see_other
    else
      # デバッグ用の遅延(ローディング画面確認用)
      sleep 2 if Rails.env.development?

      # 全ての質問に回答したらAnswerLogとAnswersを作成
      save_answers_to_database
      redirect_to coordinates_path
    end
  end

  private

  def initialize_session
    session[:diagnosis_answers] ||= {}
  end

  def save_answers_to_database
    ActiveRecord::Base.transaction do
      answer_log = current_user.answer_logs.create!

      session[:diagnosis_answers].each do |step, option_id|
        question = Question.find_by!(order: step.to_i)
        answer_log.answers.create!(
          question: question,
          option_id: option_id,
          user: current_user
        )
      end
    end
    # セッションの診断回答をクリア
    session.delete(:diagnosis_answers)
  end
end
