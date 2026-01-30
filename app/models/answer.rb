class Answer < ApplicationRecord
  belongs_to :answer_log
  belongs_to :user
  belongs_to :question
  belongs_to :option
end
