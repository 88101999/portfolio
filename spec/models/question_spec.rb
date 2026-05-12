require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能している場合は有効' do
      question = build(:question)
      expect(question).to be_valid
    end

    it '本文が入力されていない場合は無効' do
      question = build(:question, text: nil)
      expect(question).to be_invalid
      expect(question.errors[:text]).to include("を入力してください")
    end
  end

  describe 'アソシエーションチェック' do
    it { should have_many(:options) }
    it { should have_many(:answers) }
  end
end
