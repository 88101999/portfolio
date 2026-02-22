class CoordinateOption < ApplicationRecord
  belongs_to :coordinate, inverse_of: :coordinate_options
  belongs_to :option

  validates :coordinate_id, presence: true, on: :update
  validates :option_id, presence: true, uniqueness: { scope: :coordinate_id }
end
