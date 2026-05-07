require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能している場合は有効' do
      answer = build(:answer)
      expect(answer).to be_valid
    end
  end

  describe 'アソシエーションチェック' do
    it { should belong_to(:answer_log) }
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should belong_to(:option) }
  end
end
