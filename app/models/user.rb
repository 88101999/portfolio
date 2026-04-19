class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :answers
  has_many :answer_logs
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_coordinates, through: :bookmarks, source: :coordinate 
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? && crypted_password.blank?}
  validates :password, confirmation: true, if: -> { password.present? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validates :reset_password_token, uniqueness: true, allow_nil: true

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