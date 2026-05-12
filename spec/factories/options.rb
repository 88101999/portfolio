FactoryBot.define do
  factory :option do
    sequence(:name) { |n| "選択肢#{n}" }
    association :question
  end
end
