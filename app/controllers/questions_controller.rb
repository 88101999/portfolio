class QuestionsController < ApplicationController
  def new
    @questions = Question.all
  end
end
