require 'rails_helper'

RSpec.describe Coordinate, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能している場合は有効' do
      coordinate = build(:coordinate)
      expect(coordinate).to be_valid
    end

    it 'name が空の場合は無効' do
      coordinate = build(:coordinate, name: nil)
      expect(coordinate).to be_invalid
      expect(coordinate.errors[:name]).to include("を入力してください")
    end
  end

  describe 'アソシエーションチェック' do
    it { should have_many(:coordinate_options).inverse_of(:coordinate).dependent(:destroy) }
    it { should have_many(:options).through(:coordinate_options) }
    it { should have_many(:answer_logs).dependent(:nullify) }
    it { should have_one_attached(:image) }

    it 'Option を関連付けられる' do
      coordinate = create(:coordinate, :with_options)

      expect(coordinate.options.count).to eq(4)
      expect(coordinate.options.pluck(:name)).to include("メンズ系", "春", "休日のお出かけ", "カジュアル系")
    end
  end
end
