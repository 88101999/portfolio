class Coordinate < ApplicationRecord
  has_many :coordinate_options, inverse_of: :coordinate, dependent: :destroy
  has_many :options, through: :coordinate_options
  has_one_attached :image

  accepts_nested_attributes_for :coordinate_options
  
  validates :name, presence: true
  validates :image, attachment: {
    purge: true,
    content_type: %r{\Aimage/(png|jpeg|jpg)\Z},
    maximum: 10_485_760
  }

  def self.search_by_options(option_ids)
    joins(:coordinate_options)
      .where(coordinate_options: { option_id: option_ids })
      .group('coordinates.id')
      .having('COUNT(coordinate_options.option_id) = ?', option_ids.size)
  end
end
