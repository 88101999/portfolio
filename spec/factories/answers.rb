FactoryBot.define do
  factory :answer do
    association :answer_log
    association :user
    association :question
    association :option
  end
end
