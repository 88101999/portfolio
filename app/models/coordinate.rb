class Coordinate < ApplicationRecord
  has_many :coordinate_options
  has_many :options, through: :coordinate_options

  validates :name, presence: true
end
