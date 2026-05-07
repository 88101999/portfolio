FactoryBot.define do
  factory :bookmark do
    association :user
    association :coordinate
  end
end
