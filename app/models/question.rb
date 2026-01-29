class Question < ApplicationRecord
  has_many :options

  validates :text, presence: true
  validates :options, length: { minimum: 2 }
end
