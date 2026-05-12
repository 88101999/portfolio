require 'rails_helper'

RSpec.describe "ログインとログアウト", type: :system do
  let(:user) { create(:user) }

  before do
    page.driver.browser.manage.window.resize_to(1920, 1080)
  end

  describe "正常系" do
    it "ログインが成功すること" do
      visit login_path

      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"

      click_button 'ログイン'

      expect(page).to have_content 'ログインしました'
      expect(current_path).to eq root_path
    end

    it 'ログアウトが成功すること' do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'

      expect(page).to have_content 'ログインしました'
      expect(current_path).to eq root_path

      visit root_path

      click_link 'ログアウト'

      expect(page).to have_content 'ログアウトしました'
      expect(current_path).to eq root_path
    end
  end

  describe "異常系" do
    it "メールアドレスが未入力の場合、ログインに失敗すること" do
      visit login_path

      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: "password"

      click_button 'ログイン'

      expect(page).to have_content 'ログインに失敗しました'
      expect(current_path).to eq login_path
    end

    it "メールアドレスが間違っている場合、ログインに失敗すること" do
      visit login_path

      fill_in "メールアドレス", with: "wrong@example.com"
      fill_in "パスワード", with: "password"

      click_button 'ログイン'

      expect(page).to have_content 'ログインに失敗しました'
      expect(current_path).to eq login_path
    end
  end
end
