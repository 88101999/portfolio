require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'バリデーションチェック' do
    it 'すべてのバリデーションが機能している場合は有効' do
      bookmark = build(:bookmark)
      expect(bookmark).to be_valid
    end

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:coordinate_id) }
  end

  describe 'アソシエーションチェック' do
    it { should belong_to(:user) }
    it { should belong_to(:coordinate) }
  end
end