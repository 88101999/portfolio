# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
questions_data = [
  {
    text: "あなたの性別を教えてください",
    options: ["男性", "女性"]
  },
  {
    text: "どんなシーンで着ますか？",
    options: ["休日", "仕事"]
  },
  {
    text: "どんなジャンルが好きですか？",
    options: ["カジュアル系", "キレイ目系"]
  }
]

questions_data.each do |data|
  question = Question.new(text: data[:text]) do |q|
    data[:options].each do |option_name|
      q.options.build(name: option_name)
    end
  end
  question.save
end
