class AnswerLog < ApplicationRecord
  belongs_to :user
  belongs_to :coordinate, optional: true
  has_many :answers, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
end