require 'rails_helper'

RSpec.describe "お気に入り機能", type: :system do
  let(:user) { create(:user) }
  let!(:answer_log) { create(:answer_log, user: user) }

  let!(:question1) { create(:question, text: "コーディネートのタイプを選んでください", order: 1) }
  let!(:question2) { create(:question, text: "どの季節に着たいですか?", order: 2) }
  let!(:question3) { create(:question, text: "どんなときに着たいですか?", order: 3) }
  let!(:question4) { create(:question, text: "好みに近いスタイルを選んでください", order: 4) }

  let!(:option1) { create(:option, name: "メンズ系", question: question1) }
  let!(:option2) { create(:option, name: "春", question: question2) }
  let!(:option3) { create(:option, name: "休日のお出かけ", question: question3) }
  let!(:option4) { create(:option, name: "カジュアル系", question: question4) }

  let!(:coordinate) do
    coord = create(:coordinate, name: 'コーディネート0')
    coord.options = [ option1, option2, option3, option4 ]
    coord.save!
    coord
  end

  before do
    create(:answer, answer_log: answer_log, question: question1, option: option1)
    create(:answer, answer_log: answer_log, question: question2, option: option2)
    create(:answer, answer_log: answer_log, question: question3, option: option3)
    create(:answer, answer_log: answer_log, question: question4, option: option4)

    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'

    expect(page).to have_content 'ログインしました'
  end

  describe "正常系" do
    describe "お気に入り一覧表示" do
      let!(:coordinate1) do
        coord = create(:coordinate, name: 'コーディネート1')
        coord.options = [ option1, option2, option3, option4 ]
        coord
      end

      let!(:coordinate2) do
        coord = create(:coordinate, name: 'コーディネート2')
        coord.options = [ option1, option2, option3, option4 ]
        coord
      end

      let!(:coordinate3) do
        coord = create(:coordinate, name: 'コーディネート3')
        coord.options = [ option1, option2, option3, option4 ]
        coord
      end

      before do
        user.bookmarks.create!(coordinate: coordinate1)
        user.bookmarks.create!(coordinate: coordinate2)
      end

      it "お気に入り一覧ページでお気に入り登録したコーディネートのみ表示されること" do
        visit bookmarks_path

        expect(page).to have_content 'お気に入りコーディネート一覧'
        expect(page).to have_content 'コーディネート1'
        expect(page).to have_content 'コーディネート2'
        expect(page).not_to have_content 'コーディネート3'
      end

      it "お気に入りが1件もない場合、メッセージが表示されること" do
        user.bookmarks.destroy_all

        visit bookmarks_path

        expect(page).to have_content 'お気に入りのコーディネートがありません'
      end
    end
  end

  describe "異常系" do
    describe "未ログイン状態でのアクセス" do
      before do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end

      it "お気に入り一覧ページにアクセスするとログインページにリダイレクトされること" do
        visit bookmarks_path

        expect(page).to have_current_path(login_path)
        expect(page).to have_content 'ログインしてください'
      end

      it "コーディネート一覧ページにアクセスするとログインページにリダイレクトされること" do
        visit coordinates_path

        expect(page).to have_current_path(login_path)
        expect(page).to have_content 'ログインしてください'
      end
    end
  end
end
