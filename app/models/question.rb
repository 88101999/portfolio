class Question < ApplicationRecord
  has_many :options
  has_many :answers

  validates :text, presence: true
  validates :options, length: { minimum: 2 }
end
