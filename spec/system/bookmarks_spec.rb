require 'rails_helper'

RSpec.describe "お気に入り機能", type: :system do
  let(:user) { create(:user) }
  let!(:answer_log) { create(:answer_log, user: user) }

  # 質問を先に作成
  let!(:question1) { create(:question, text: "性別を選択してください", order: 1) }
  let!(:question2) { create(:question, text: "季節を選択してください", order: 2) }
  let!(:question3) { create(:question, text: "シーンを選択してください", order: 3) }
  let!(:question4) { create(:question, text: "スタイルを選択してください", order: 4) }

  # 質問に関連付けられたOptionを作成
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
    # 回答を作成
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
    describe "お気に入り登録" do
      it "コーディネート一覧ページからモーダル経由でお気に入り登録できること" do
        visit coordinates_path

        expect(page).to have_css("#coordinate-card-#{coordinate.id}")

        find("#coordinate-card-#{coordinate.id}").click

        expect(page).to have_css("#coordinateModal#{coordinate.id}", visible: :all, wait: 10)
        expect(page).to have_css("#coordinateModal#{coordinate.id}.modal", visible: :all, wait: 10)
        expect(page).to have_css("#coordinateModal#{coordinate.id}.show", wait: 15)

        modal = find("#coordinateModal#{coordinate.id}")
        expect(modal).to be_visible


        within("#coordinateModal#{coordinate.id}") do
          button = find_button('お気に入りに追加', wait: 10)
          expect(button).to be_visible
          button.click

          expect(page).to have_button 'お気に入りから削除', wait: 10
        end

        user.reload
        expect(user.bookmarks.count).to eq 1
        expect(user.bookmarked_coordinates).to include(coordinate)
      end
    end

    describe "お気に入り解除" do
      before do
        user.bookmarks.create!(coordinate: coordinate)
      end

      it "コーディネート一覧ページからモーダル経由でお気に入り解除できること" do
        visit coordinates_path

        expect(page).to have_css("#coordinate-card-#{coordinate.id}")

        find("#coordinate-card-#{coordinate.id}").click

        # モーダルが DOM に存在することを確認（表示・非表示は問わない）
        expect(page).to have_css("#coordinateModal#{coordinate.id}.show", visible: :all, wait: 10)
        # モーダル内のボタンが表示されるまで待機
        within("#coordinateModal#{coordinate.id}",) do
          expect(page).to have_button 'お気に入りから削除', wait: 10

          click_button 'お気に入りから削除'

          expect(page).to have_button 'お気に入りに追加', wait: 10
        end

        user.reload
        expect(user.bookmarks.count).to eq 0
        expect(user.bookmarked_coordinates).not_to include(coordinate)
      end
    end

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

      it "お気に入り一覧ページからモーダルを開けること" do
        visit bookmarks_path

        expect(page).to have_css("#bookmark-card-#{coordinate1.id}")

        find("#bookmark-card-#{coordinate1.id}").click

        expect(page).to have_css("#coordinateModal#{coordinate1.id}.show", wait: 5)

        within("#coordinateModal#{coordinate1.id}") do
          expect(page).to have_content 'コーディネート1'
        end
      end

      it "お気に入り一覧ページからモーダル経由でお気に入り解除できること" do
        visit bookmarks_path
        find("#bookmark-card-#{coordinate1.id}").click

        expect(page).to have_css("#coordinateModal#{coordinate1.id}.show", wait: 5)

        within("#coordinateModal#{coordinate1.id}") do
          accept_confirm do
            click_button 'お気に入りから削除'
          end
        end

        expect(page).not_to have_css("#bookmark-card-#{coordinate1.id}", wait: 5)

        user.reload
        expect(user.bookmarks.count).to eq 1
        expect(user.bookmarked_coordinates).not_to include(coordinate1)
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

    describe "重複登録の防止" do
      it "同じコーディネートを2回お気に入り登録しようとすると2つ目は登録されないこと" do
        visit coordinates_path

        find("#coordinate-card-#{coordinate.id}").click

        within("#coordinateModal#{coordinate.id}") do
          click_button 'お気に入りに追加'
          expect(page).to have_button 'お気に入りから削除', wait: 5
        end

        user.reload
        expect(user.bookmarks.count).to eq 1

        visit coordinates_path

        find("#coordinate-card-#{coordinate.id}").click

        within("#coordinateModal#{coordinate.id}") do
          expect(page).to have_button 'お気に入りから削除'
          expect(page).not_to have_button 'お気に入りに追加'
        end

        user.reload
        expect(user.bookmarks.count).to eq 1
      end
    end
  end
end
