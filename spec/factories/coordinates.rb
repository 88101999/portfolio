FactoryBot.define do
  factory :coordinate do
    sequence(:name) { |n| "コーディネート#{n}" }
    description { "Tシャツ+デニムパンツ+スニーカー" }
    image_url { "https://example.com/image.png" }

    # Option との関連付け
    trait :with_options do
      after(:create) do |coordinate|
        option1 = Option.find_or_create_by(name: "メンズ系")
        option2 = Option.find_or_create_by(name: "春")
        option3 = Option.find_or_create_by(name: "休日のお出かけ")
        option4 = Option.find_or_create_by(name: "カジュアル系")
        coordinate.options << [option1, option2, option3, option4]
      end
    end
  end
end