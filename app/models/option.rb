class Option < ApplicationRecord
  belongs_to :question
  has_many :answers
  has_many :coordinate_options
  has_many :coordinates, through: :coordinate_options

  validates :name, presence: true
end
