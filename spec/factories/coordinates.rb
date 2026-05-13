FactoryBot.define do
  factory :coordinate do
    sequence(:name) { |n| "コーディネート#{n}" }
    description { "Tシャツ+デニムパンツ+スニーカー" }
    image_url { "https://example.com/image.png" }

    # Option との関連付け
    trait :with_options do
      after(:create) do |coordinate|
        # 各 Option に question を関連付けて作成
        question1 = create(:question)
        question2 = create(:question)
        question3 = create(:question)
        question4 = create(:question)

        option1 = create(:option, name: "メンズ系", question: question1)
        option2 = create(:option, name: "春", question: question2)
        option3 = create(:option, name: "休日のお出かけ", question: question3)
        option4 = create(:option, name: "カジュアル系", question: question4)

        coordinate.options << [ option1, option2, option3, option4 ]
      end
    end
  end
end
