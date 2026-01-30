class CoordinateOption < ApplicationRecord
  belongs_to :coordinate
  belongs_to :option

  validates :coordinate_id, presence: true
  validates :option_id, presence: true, uniqueness: { scope: :coordinate_id }
end
