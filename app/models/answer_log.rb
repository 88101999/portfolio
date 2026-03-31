class AnswerLog < ApplicationRecord
  belongs_to :user
  has_many :answers
  has_many :bookmarks, dependent: :destroy
end
