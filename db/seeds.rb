require 'open-uri'

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

coordinates_data = [
  {
    name: "メンズカジュアル仕事コーデ(春)",
    description: "オックスフォードシャツ＋テーパードチノパン＋白スニーカー",
    options: [ "メンズ系", "春", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662571/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_wimpmt.png"
  },
  {
    name: "メンズキレイ目仕事コーデ(春)",
    description: "バンドカラーシャツ+テーパードスラックス+レザーシューズ",
    options: [ "メンズ系", "春", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662571/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_q4nsrx.png"
  },
  {
    name: "メンズストリート仕事コーデ(春)",
    description: "無地スウェット＋黒ワイドパンツ＋ローカットスニーカー",
    options: [ "メンズ系", "春", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662572/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_a3ldkp.png"
  },
  {
    name: "メンズカジュアル休日コーデ(春)",
    description: "ボーダーカットソー＋ストレートデニム＋キャンバススニーカー",
    options: [ "メンズ系", "春", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662571/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_gnf2in.png"
  },
  {
    name: "メンズキレイ目休日コーデ(春)",
    description: "ニットポロ＋センタープレスパンツ＋ローファー",
    options: [ "メンズ系", "春", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662571/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_cyrqrj.png"
  },
  {
    name: "メンズストリート休日コーデ(春)",
    description: "オーバーサイズTシャツ＋ワイドデニム＋ボリュームスニーカー",
    options: [ "メンズ系", "春", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662568/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_ntmoun.png"
  },
  {
    name: "メンズカジュアルイベントコーデ(春)",
    description: "デニムジャケット＋白Tシャツ＋黒スラックス＋レザースニーカー",
    options: [ "メンズ系", "春", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662567/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_at2edy.png"
  },
  {
    name: "メンズキレイ目イベントコーデ(春)",
    description: "テーラードジャケット＋白シャツ＋細身スラックス＋レザーシューズ",
    options: [ "メンズ系", "春", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662568/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_sgblgx.png"
  },
  {
    name: "メンズストリートイベントコーデ(春)",
    description: "コーチジャケット＋無地Tシャツ＋黒ワイドパンツ＋ハイカットスニーカー",
    options: [ "メンズ系", "春", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662566/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_gwgbsw.png"
  },
  {
    name: "メンズカジュアル仕事コーデ(夏)",
    description: "半袖シャツ＋テーパードパンツ＋白スニーカー",
    options: [ "メンズ系", "夏", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662566/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_vmljsu.png"
  },
  {
    name: "メンズキレイ目仕事コーデ(夏)",
    description: "サマーニット＋スラックス＋ローファー",
    options: [ "メンズ系", "夏", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662565/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_yuidor.png"
  },
  {
    name: "メンズストリート仕事コーデ(夏)",
    description: "ビッグTシャツ＋黒スキニーパンツ＋スニーカー",
    options: [ "メンズ系", "夏", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662564/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_d1dqyo.png"
  },
  {
    name: "メンズカジュアル休日コーデ(夏)",
    description: "ポロシャツ＋デニムパンツ＋スニーカー",
    options: [ "メンズ系", "夏", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662561/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_uhqyxv.png"
  },
  {
    name: "メンズキレイ目休日コーデ(夏)",
    description: "半袖リネンシャツ＋アンクルパンツ＋レザーサンダル",
    options: [ "メンズ系", "夏", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662560/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_vbmloh.png"
  },
  {
    name: "メンズストリート休日コーデ(夏)",
    description: "グラフィックTシャツ＋カーゴパンツ＋ボリュームスニーカー",
    options: [ "メンズ系", "夏", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662561/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_tw4xcy.png"
  },
  {
    name: "メンズカジュアルイベントコーデ(夏)",
    description: "半袖開襟シャツ＋黒スラックス＋レザースニーカー",
    options: [ "メンズ系", "夏", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662560/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_grbid5.png"
  },
  {
    name: "メンズキレイ目イベントコーデ(夏)",
    description: "半袖バンドカラーシャツ＋細身スラックス＋ローファー",
    options: [ "メンズ系", "夏", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662560/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_xxenrc.png"
  },
  {
    name: "メンズストリートイベントコーデ(夏)",
    description: "半袖オーバーサイズシャツ＋ワイドパンツ＋ハイカットスニーカー",
    options: [ "メンズ系", "夏", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662559/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_tkbfe3.png"
  },
  {
    name: "メンズカジュアル仕事コーデ(秋)",
    description: "カーディガン＋白シャツ＋チノパン＋スニーカー",
    options: [ "メンズ系", "秋", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662558/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_c8otro.png"
  },
  {
    name: "メンズキレイ目仕事コーデ(秋)",
    description: "テーラードジャケット＋バンドカラーシャツ＋スラックス＋レザーシューズ",
    options: [ "メンズ系", "秋", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662556/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_pw3rat.png"
  },
  {
    name: "メンズストリート仕事コーデ(秋)",
    description: "パーカー＋黒パンツ＋スニーカー",
    options: [ "メンズ系", "秋", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662556/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_kmiigy.png"
  },
  {
    name: "メンズカジュアル休日コーデ(秋)",
    description: "チェックシャツ＋デニムパンツ＋スニーカー",
    options: [ "メンズ系", "秋", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662555/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_ra0osf.png"
  },
  {
    name: "メンズキレイ目休日コーデ(秋)",
    description: "ハイゲージニット＋テーパードパンツ＋ローファー",
    options: [ "メンズ系", "秋", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662555/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_xbx4cg.png"
  },
  {
    name: "メンズストリート休日コーデ(秋)",
    description: "スウェット＋カーゴパンツ＋ボリュームスニーカー",
    options: [ "メンズ系", "秋", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662554/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_lwpyty.png"
  },
  {
    name: "メンズカジュアルイベントコーデ(秋)",
    description: "ブルゾン＋白Tシャツ＋黒スラックス＋レザースニーカー",
    options: [ "メンズ系", "秋", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662554/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_uwmbvt.png"
  },
  {
    name: "メンズキレイ目イベントコーデ(秋)",
    description: "チェスターコート＋シャツ＋スラックス＋レザーシューズ",
    options: [ "メンズ系", "秋", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662553/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_wae8u8.png"
  },
  {
    name: "メンズストリートイベントコーデ(秋)",
    description: "スタジャン＋グレースウェット＋黒ワイドパンツ＋ハイカットスニーカー",
    options: [ "メンズ系", "秋", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662551/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_ct3rrm.png"
  },
  {
    name: "メンズカジュアル仕事コーデ(冬)",
    description: "ダウンジャケット＋ニット＋チノパン＋スニーカー",
    options: [ "メンズ系", "冬", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662551/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_gaz9vn.png"
  },
  {
    name: "メンズキレイ目仕事コーデ(冬)",
    description: "チェスターコート＋シャツ＋スラックス＋レザーシューズ",
    options: [ "メンズ系", "冬", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662550/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_nwvz13.png"
  },
  {
    name: "メンズストリート仕事コーデ(冬)",
    description: "中綿ブルゾン＋スウェット＋黒パンツ＋スニーカー",
    options: [ "メンズ系", "冬", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662550/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_l0ae6g.png"
  },
  {
    name: "メンズカジュアル休日コーデ(冬)",
    description: "ボアジャケット＋ニット＋デニム＋スニーカー",
    options: [ "メンズ系", "冬", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662548/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_x0bxnl.png"
  },
  {
    name: "メンズキレイ目休日コーデ(冬)",
    description: "ウールコート＋タートルネックニット＋テーパードパンツ＋ローファー",
    options: [ "メンズ系", "冬", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662547/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_jyftjh.png"
  },
  {
    name: "メンズストリート休日コーデ(冬)",
    description: "ダウンジャケット＋パーカー＋ワイドパンツ＋ボリュームスニーカー",
    options: [ "メンズ系", "冬", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662547/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_hnoyqh.png"
  },
  {
    name: "メンズカジュアルイベントコーデ(冬)",
    description: "レザージャケット＋ニット＋黒スラックス＋レザーシューズ",
    options: [ "メンズ系", "冬", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662546/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_qflq3u.png"
  },
  {
    name: "メンズキレイ目イベントコーデ(冬)",
    description: "ロングコート＋シャツ＋細身スラックス＋ドレスシューズ",
    options: [ "メンズ系", "冬", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662546/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_dptrwj.png"
  },
  {
    name: "メンズストリートイベントコーデ(冬)",
    description: "ダウンジャケット＋スウェット＋カーゴパンツ＋ハイカットスニーカー",
    options: [ "メンズ系", "冬", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662545/%E3%83%A1%E3%83%B3%E3%82%B9%E3%82%99%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_anx4cp.png"
  },
  {
    name: "レディースカジュアル仕事コーデ(春)",
    description: "ブラウス＋テーパードパンツ＋パンプス",
    options: [ "レディース系", "春", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662546/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_gjemwc.png"
  },
  {
    name: "レディースキレイ目仕事コーデ(春)",
    description: "ノーカラージャケット＋ブラウス＋スラックス＋ローファー",
    options: [ "レディース系", "春", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662543/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_shrpe5.png"
  },
  {
    name: "レディースストリート仕事コーデ(春)",
    description: "スウェット＋ワイドパンツ＋スニーカー",
    options: [ "レディース系", "春", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662541/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_euaib9.png"
  },
  {
    name: "レディースカジュアル休日コーデ(春)",
    description: "カーディガン＋Tシャツ＋デニム＋スニーカー",
    options: [ "レディース系", "春", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662540/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_w5qztd.png"
  },
  {
    name: "レディースキレイ目休日コーデ(春)",
    description: "ニット＋フレアスカート＋パンプス",
    options: [ "レディース系", "春", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662541/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_kbo9uo.png"
  },
  {
    name: "レディースストリート休日コーデ(春)",
    description: "オーバーサイズTシャツ＋カーゴパンツ＋ボリュームスニーカー",
    options: [ "レディース系", "春", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662541/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_euaib9.png"
  },
  {
    name: "レディースカジュアルイベントコーデ(春)",
    description: "デニムジャケット＋ワンピース＋パンプス",
    options: [ "レディース系", "春", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662536/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_jvszyb.png"
  },
  {
    name: "レディースキレイ目イベントコーデ(春)",
    description: "トレンチコート＋ブラウス＋タイトスカート＋ヒール",
    options: [ "レディース系", "春", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662538/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_cjjcw7.png"
  },
  {
    name: "レディースストリートイベントコーデ(春)",
    description: "ブルゾン＋Tシャツ＋ロングスカート＋スニーカー",
    options: [ "レディース系", "春", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662536/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E6%98%A5_s9k44f.png"
  },
  {
    name: "レディースカジュアル仕事コーデ(夏)",
    description: "半袖ブラウス＋テーパードパンツ＋ローファー",
    options: [ "レディース系", "夏", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662538/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_xpyfm7.png"
  },
  {
    name: "レディースキレイ目仕事コーデ(夏)",
    description: "サマーニット＋スラックス＋パンプス",
    options: [ "レディース系", "夏", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662535/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_fht125.png"
  },
  {
    name: "レディースストリート仕事コーデ(夏)",
    description: "Tシャツ＋ワイドパンツ＋スニーカー",
    options: [ "レディース系", "夏", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662536/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_ezqpkc.png"
  },
  {
    name: "レディースカジュアル休日コーデ(夏)",
    description: "半袖ワンピース＋スニーカー",
    options: [ "レディース系", "夏", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662533/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_so0j75.png"
  },
  {
    name: "レディースキレイ目休日コーデ(夏)",
    description: "半袖ブラウス＋ロングスカート＋サンダル",
    options: [ "レディース系", "夏", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662535/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_tfnyss.png"
  },
  {
    name: "レディースストリート休日コーデ(夏)",
    description: "オーバーサイズTシャツ＋ショートパンツ＋スニーカー",
    options: [ "レディース系", "夏", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662533/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_mq8lwl.png"
  },
  {
    name: "レディースカジュアルイベントコーデ(夏)",
    description: "リネンカーディガン＋ワンピース＋パンプス",
    options: [ "レディース系", "夏", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662532/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_jmqtfj.png"
  },
  {
    name: "レディースキレイ目イベントコーデ(夏)",
    description: "ノースリーブブラウス＋タイトスカート＋ヒール",
    options: [ "レディース系", "夏", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662533/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_hthemo.png"
  },
  {
    name: "レディースストリートイベントコーデ(夏)",
    description: "半袖オーバーサイズシャツ＋ワイドパンツ＋ボリュームスニーカー",
    options: [ "レディース系", "夏", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662531/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%A4%8F_whuabg.png"
  },
  {
    name: "レディースカジュアル仕事コーデ(秋)",
    description: "ニット＋テーパードパンツ＋ローファー",
    options: [ "レディース系", "秋", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662447/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_edrsuc.png"
  },
  {
    name: "レディースキレイ目仕事コーデ(秋)",
    description: "テーラードジャケット＋ブラウス＋スラックス＋パンプス",
    options: [ "レディース系", "秋", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662428/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_efvqhd.png"
  },
  {
    name: "レディースストリート仕事コーデ(秋)",
    description: "パーカー＋ワイドパンツ＋スニーカー",
    options: [ "レディース系", "秋", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662429/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_zahewc.png"
  },
  {
    name: "レディースカジュアル休日コーデ(秋)",
    description: "カーディガン＋ワンピース＋スニーカー",
    options: [ "レディース系", "秋", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662427/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_nlhnko.png"
  },
  {
    name: "レディースキレイ目休日コーデ(秋)",
    description: "ニット＋ロングスカート＋ブーツ",
    options: [ "レディース系", "秋", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662427/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_zahdpy.png"
  },
  {
    name: "レディースストリート休日コーデ(秋)",
    description: "スウェット＋カーゴパンツ＋ボリュームスニーカー",
    options: [ "レディース系", "秋", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662426/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_h3h7be.png"
  },
  {
    name: "レディースカジュアルイベントコーデ(秋)",
    description: "ブルゾン＋ワンピース＋ブーツ",
    options: [ "レディース系", "秋", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662424/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_lrxi5l.png"
  },
  {
    name: "レディースキレイ目イベントコーデ(秋)",
    description: "チェスターコート＋ブラウス＋タイトスカート＋ヒール",
    options: [ "レディース系", "秋", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662423/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_thh9ks.png"
  },
  {
    name: "レディースストリートイベントコーデ(秋)",
    description: "スタジャン＋スウェット＋ロングスカート＋スニーカー",
    options: [ "レディース系", "秋", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662422/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E7%A7%8B_e2ql4f.png"
  },
  {
    name: "レディースカジュアル仕事コーデ(冬)",
    description: "ダウンコート＋ニット＋テーパードパンツ＋ローファー",
    options: [ "レディース系", "冬", "仕事、学校", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662424/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_j0qxea.png"
  },
  {
    name: "レディースキレイ目仕事コーデ(冬)",
    description: "ロングコート＋ブラウス＋スラックス＋パンプス",
    options: [ "レディース系", "冬", "仕事、学校", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662423/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_nqkhxj.png"
  },
  {
    name: "レディースストリート仕事コーデ(冬)",
    description: "中綿ブルゾン＋スウェット＋ワイドパンツ＋スニーカー",
    options: [ "レディース系", "冬", "仕事、学校", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662421/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BB%95%E4%BA%8B%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_sn0u30.png"
  },
  {
    name: "レディースカジュアル休日コーデ(冬)",
    description: "ボアコート＋ニット＋デニム＋スニーカー",
    options: [ "レディース系", "冬", "休日のお出かけ", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662428/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_cnly1p.png"
  },
  {
    name: "レディースキレイ目休日コーデ(冬)",
    description: "ウールコート＋タートルネックニット＋ロングスカート＋ブーツ",
    options: [ "レディース系", "冬", "休日のお出かけ", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662422/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_dzilwt.png"
  },
  {
    name: "レディースストリート休日コーデ(冬)",
    description: "ダウンジャケット＋パーカー＋カーゴパンツ＋ボリュームスニーカー",
    options: [ "レディース系", "冬", "休日のお出かけ", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662420/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E4%BC%91%E6%97%A5%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_p4aj41.png"
  },
  {
    name: "レディースカジュアルイベントコーデ(冬)",
    description: "ショートコート＋ワンピース＋ブーツ",
    options: [ "レディース系", "冬", "特別な日(デート、イベントなど)", "カジュアル系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662420/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AB%E3%82%B7%E3%82%99%E3%83%A5%E3%82%A2%E3%83%AB%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_ws44ix.png"
  },
  {
    name: "レディースキレイ目イベントコーデ(冬)",
    description: "ロングコート＋ブラウス＋タイトスカート＋ヒール",
    options: [ "レディース系", "冬", "特別な日(デート、イベントなど)", "キレイ目系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662420/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%AD%E3%83%AC%E3%82%A4%E7%9B%AE%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_fy7w9u.png"
  },
  {
    name: "レディースストリートイベントコーデ(冬)",
    description: "ダウンジャケット＋スウェット＋ワイドパンツ＋スニーカー",
    options: [ "レディース系", "冬", "特別な日(デート、イベントなど)", "ストリート系" ],
    image_url: "https://res.cloudinary.com/du99twksg/image/upload/v1773662420/%E3%83%AC%E3%83%86%E3%82%99%E3%82%A3%E3%83%BC%E3%82%B9%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%88%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E3%82%B3%E3%83%BC%E3%83%86%E3%82%99_%E5%86%AC_eypc6c.png"
  }
]

if Question.exists?
  puts "⚠️ データが既に存在するため、削除処理をスキップします"
  puts "=== 画像添付処理のみ実行します ==="

  coordinates_data.each do |data|
    coordinate = Coordinate.find_by(name: data[:name])
    next unless coordinate

    if data[:image_url].present?
      coordinate.image.purge if coordinate.image.attached? # 既存の画像を削除

      begin
        downloaded_image = URI.open(data[:image_url])
        coordinate.image.attach(io: downloaded_image, filename: "#{data[:name]}.png", content_type: 'image/png')
        puts "✅ 画像を添付しました: #{data[:name]}"
      rescue => e
        puts "❌ 画像の添付に失敗しました: #{data[:name]} - #{e.message}"
      end
    else
      puts "⚠️ 画像URLが設定されていません: #{data[:name]}"
    end
  end

  puts "=== 画像添付処理が完了しました ==="
  exit
end


puts "=== 既存データをクリアします ==="
Answer.destroy_all
CoordinateOption.destroy_all
Coordinate.destroy_all
Option.destroy_all
Question.destroy_all
puts "✅ クリア完了！"

questions_data.each do |data|
  question = Question.find_or_create_by!(text: data[:text]) do |q|
    q.order = data [:order]
  end

  data[:options].each do |option_name|
    option = Option.find_or_create_by!(name: option_name, question: question)
  end
end

puts "✅ #{Question.count} questions created!"
puts "✅ #{Option.count} options created!"
puts ""

coordinates_data.each do |data|
  coordinate = Coordinate.find_or_create_by!(name: data[:name]) do |c|
    c.description = data[:description]
  end

  data[:options].each do |option_name|
    option = Option.find_by(name: option_name)

    if option.nil?
      puts "⚠️ Warning: Option '#{option_name}' not found for coordinate '#{data[:name]}'"
      next
    end

    unless coordinate.options.include?(option)
      coordinate.coordinate_options.create!(option: option)
    end
  end

  if data[:image_url].present? && !coordinate.image.attached?
    begin
      downloaded_image = URI.open(data[:image_url])
      coordinate.image.attach(io: downloaded_image, filename: "#{data[:name]}.png", content_type: 'image/png')
      puts "✅ 画像を添付しました: #{data[:name]}"
    rescue => e
      puts "❌ 画像の添付に失敗しました: #{data[:name]} - #{e.message}"
    end
  end
end

puts ""
puts "=== シードデータの投入が完了しました ==="
puts "✅ Questions: #{Question.count}"
puts "✅ Options: #{Option.count}"
puts "✅ Coordinates: #{Coordinate.count}"
puts "✅ CoordinateOptions: #{CoordinateOption.count}"
