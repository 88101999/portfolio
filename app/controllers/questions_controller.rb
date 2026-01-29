class QuestionsController < ApplicationController
  def new
    @question = Question.all
  end
end
