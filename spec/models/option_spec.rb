require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能している場合は有効' do
      option = build(:option)
      expect(option).to be_valid
    end

    it '選択肢が入力されていない場合は無効' do
      option = build(:option, name: nil)
      expect(option).to be_invalid
      expect(option.errors[:name]).to include("を入力してください")
    end

    it 'questionが関連付けられていない場合は無効' do
      option = build(:option, question: nil)
      expect(option).to be_invalid
      expect(option.errors[:question]).to include("を入力してください")
    end
  end

  describe 'アソシエーションチェック' do
    it { should belong_to(:question) }
    it { should have_many(:answers) }
    it { should have_many(:coordinate_options) }
    it { should have_many(:coordinates).through(:coordinate_options) }
  end
end
