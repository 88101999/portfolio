FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "質問#{n}" }
    sequence(:order)
  end
end