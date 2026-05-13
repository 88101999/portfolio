require 'rails_helper'

RSpec.describe "コーディネート提案", type: :system do
  let(:user) { create(:user) }

  before do
    page.driver.browser.manage.window.resize_to(1920, 1080)
  end

  before do
    Answer.destroy_all
    CoordinateOption.destroy_all
    Option.destroy_all
    Question.destroy_all

    create_questions_and_options

    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'

    expect(page).to have_content 'ログインしました'
    expect(current_path).to eq root_path

    visit root_path
  end

  describe "正常系" do
    it "すべての質問に回答してコーディネート提案が成功すること" do
      # 既存の質問から Option を取得
      option1 = Option.find_by(name: "メンズ系")
      option2 = Option.find_by(name: "春")
      option3 = Option.find_by(name: "休日のお出かけ")
      option4 = Option.find_by(name: "カジュアル系")

      # Coordinate を作成して、既存の Option を関連付ける
      coordinate = create(:coordinate)
      coordinate.options << [ option1, option2, option3, option4 ]

      # AI APIのモック化
      allow_any_instance_of(CoordinateRecommendationService)
        .to receive(:call)
        .and_return('このコーディネートは春の休日にぴったりです。')

      visit step_diagnoses_path(step: 1)

      expect(page).to have_content 'コーディネートのタイプを選んでください'
      find('label', text: 'メンズ系').click
      click_button '次へ'

      expect(page).to have_content 'どの季節に着たいですか?'
      find('label', text: '春').click
      click_button '次へ'

      expect(page).to have_content 'どんなときに着たいですか?'
      find('label', text: '休日のお出かけ').click
      click_button '次へ'

      expect(page).to have_content '好みに近いスタイルを選んでください'
      find('label', text: 'カジュアル系').click
      click_button 'コーディネートを見る'

      expect(page).to have_current_path(coordinates_path, wait: 10)

      expect(page).to have_content coordinate.name

      expect(user.answer_logs.count).to eq 1
      answer_log = user.answer_logs.last
      expect(answer_log.answers.count).to eq 4

      expect(answer_log.answers.pluck(:option_id)).to match_array(
        Option.where(name: [ 'メンズ系', '春', '休日のお出かけ', 'カジュアル系' ]).pluck(:id)
      )
    end
  end
end

private

def create_questions_and_options
  questions_data = [
    {
      text: "コーディネートのタイプを選んでください",
      options: [ "メンズ系", "レディース系" ],
      order: 1
    },
    {
      text: "どの季節に着たいですか?",
      options: [ "春", "夏", "秋", "冬" ],
      order: 2
    },
    {
      text: "どんなときに着たいですか?",
      options: [ "仕事、学校", "休日のお出かけ", "特別な日(デート、イベントなど)" ],
      order: 3
    },
    {
      text: "好みに近いスタイルを選んでください",
      options: [ "カジュアル系", "キレイ目系", "ストリート系" ],
      order: 4
    }
  ]

  questions_data.each do |q_data|
    question = create(:question, text: q_data[:text], order: q_data[:order])
    q_data[:options].each do |option_name|
      create(:option, name: option_name, question: question)
    end
  end
end
