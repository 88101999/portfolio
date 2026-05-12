require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  let(:user_attributes) { attributes_for(:user) }

  describe '正常系' do
    it 'ユーザー登録が成功すること' do
      visit new_user_path

      fill_in 'ユーザーネーム', with: user_attributes[:name]
      fill_in 'メールアドレス', with: user_attributes[:email]
      fill_in 'パスワード', with: user_attributes[:password]
      fill_in 'パスワード確認', with: user_attributes[:password]

      click_button '登録する'

      expect(page).to have_content 'ユーザー登録が完了しました'
      expect(current_path).to eq root_path
    end
  end

  describe '異常系' do
    it 'ユーザーネームが未入力の場合、ユーザー登録が失敗すること' do
      visit new_user_path

      fill_in 'メールアドレス', with: user_attributes[:email]
      fill_in 'パスワード', with: user_attributes[:password]
      fill_in 'パスワード確認', with: user_attributes[:password]

      click_button '登録する'
      expect(page).to have_content 'ユーザー登録に失敗しました'
      expect(current_path).to eq new_user_path
    end

    it 'メールアドレスが重複している場合、ユーザー登録が失敗すること' do
      create(:user, email: user_attributes[:email])
      visit new_user_path

      fill_in 'ユーザーネーム', with: user_attributes[:name]
      fill_in 'メールアドレス', with: user_attributes[:email]
      fill_in 'パスワード', with: user_attributes[:password]
      fill_in 'パスワード確認', with: user_attributes[:password]

      click_button '登録する'
      expect(page).to have_content 'ユーザー登録に失敗しました'
      expect(current_path).to eq new_user_path
    end

    it 'パスワードとパスワード確認が一致しない場合、ユーザー登録が失敗すること' do
      visit new_user_path

      fill_in 'ユーザーネーム', with: user_attributes[:name]
      fill_in 'メールアドレス', with: user_attributes[:email]
      fill_in 'パスワード', with: user_attributes[:password]
      fill_in 'パスワード確認', with: 'different_password'

      click_button '登録する'
      expect(page).to have_content 'ユーザー登録に失敗しました'
      expect(current_path).to eq new_user_path
    end
  end
end
