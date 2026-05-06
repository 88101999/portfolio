class AnswerLog < ApplicationRecord
  belongs_to :user
  has_many :coordinates, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
end