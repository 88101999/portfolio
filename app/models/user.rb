class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :answers
  has_many :answer_logs
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_coordinates, through: :bookmarks, source: :coordinate 

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def bookmark(coordinate)
    bookmarked_coordinates << coordinate
  end

  def unbookmark(coordinate)
    bookmarked_coordinates.destroy(coordinate)
  end

  def bookmarked?(coordinate)
    bookmarked_coordinates.include?(coordinate)
  end
end
