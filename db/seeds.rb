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

coordinates_data = [
  {
    name: "メンズカジュアル休日コーデ",
    description: "オーバーサイズTシャツ+ワイドデニム+ボリュームスニーカー",
    options: ["男性", "休日", "カジュアル系"]
  },
  {
    name: "メンズキレイ目休日コーデ",
    description: "バンドカラーシャツ+テーパードスラックス+レザーシューズ",
    options: ["男性", "休日", "キレイ目系"]
  },
  {
    name: "メンズカジュアル仕事コーデ",
    description: "ニットポロシャツ+チノパン+ローファー",
    options: ["男性", "仕事", "カジュアル系"]
  },
  {
    name: "メンズキレイ目仕事コーデ",
    description: "ネイビージャケット+スラックス+ストレートチップ革靴",
    options: ["男性", "仕事", "キレイ目系"] 
  },
  {
    name: "レディースカジュアル休日コーデ",
    description: "クロップドトップス+ハイウエストワイドパンツ+スニーカー",
    options: ["女性", "休日", "カジュアル系"]
  },
  {
    name: "レディースキレイ目休日コーデ",
    description: "ブラウス+フレアスカート+パンプス",
    options: ["女性", "休日", "キレイ目系"]
  },
  {
    name: "レディースカジュアル仕事コーデ",
    description: "デザインブラウス+センタープレスパンツ+フラットシューズ",
    options: ["女性", "仕事", "カジュアル系"]
  },
  {
    name: "レディースキレイ目仕事コーデ",
    description: "ノーカラージャケット+ワイドパンツ+ヒールパンプス",
    options: ["女性", "仕事", "キレイ目系"]
  }
]

coordinates_data.each do |data|
  puts "=== データ処理開始 ==="
  puts "name: #{data[:name]}"
  
  # まず Coordinate だけを作成して保存
  coordinate = Coordinate.new(name: data[:name], description: data[:description])
  
  puts "coordinate を保存します: #{coordinate.inspect}"
  
  if coordinate.save
    puts "保存成功! coordinate.id = #{coordinate.id}"
    
    # 保存後に options を関連付ける
    data[:options].each do |option_name|
      puts "option_name を探しています: #{option_name}"
      option = Option.find_by!(name: option_name)
      puts "見つかった option: #{option.inspect}"
      coordinate.options << option
    end
    
    puts "options の関連付け完了"
  else
    puts "保存失敗!"
    puts "エラー: #{coordinate.errors.full_messages}"
  end
end