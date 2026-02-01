class Coordinate < ApplicationRecord
  has_many :coordinate_options
  has_many :options, through: :coordinate_options

  validates :name, presence: true

  def self.search_by_options(option_ids)
    joins(:coordinate_options)
      .where(coordinate_options: { option_id: option_ids })
      .group('coordinates.id')
      .having('COUNT(coordinate_options.option_id) = ?', option_ids.size)
  end
end
