require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能している場合は有効' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '名前が入力されていない場合は無効' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it 'メールアドレスが入力されていない場合は無効' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'メールアドレスがすでに存在する場合は無効' do
      create(:user, email: 'user@example.com')
      user = build(:user, email: 'user@example.com')
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it 'パスワードが入力されていない場合は無効' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("を入力してください")
    end

    it 'パスワードが3文字未満の場合は無効' do
      user = build(:user, password: 'ab', password_confirmation: 'ab')
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end

    it 'パスワード確認で同じパスワードが入力されていない場合は無効' do
      user = build(:user, password: 'password', password_confirmation: 'password123')
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end

  describe 'アソシエーションチェック' do
    it { should have_many(:answers) }
    it { should have_many(:answer_logs) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmarked_coordinates).through(:bookmarks).source(:coordinate) }
    it { should have_many(:authentications).dependent(:destroy) }
  end
end
