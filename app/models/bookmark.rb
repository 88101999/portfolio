class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :coordinate

  validates :user_id, uniqueness: { scope: :coordinate_id }
end

