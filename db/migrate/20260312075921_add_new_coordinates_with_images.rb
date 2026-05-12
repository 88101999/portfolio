class AddNewCoordinatesWithImages < ActiveRecord::Migration[7.2]
  def up
    # seeds/images/ 内のすべての .png ファイルを取得
    image_files = Dir.glob(Rails.root.join('db', 'seeds', 'images', '*.png')).map { |path| File.basename(path) }

    puts "📁 見つかった画像ファイル: #{image_files.count}件"

    success_count = 0
    skip_count = 0
    error_count = 0

    image_files.each do |image_filename|
      # ファイル名から拡張子を除いてコーディネート名とする
      coordinate_name = File.basename(image_filename, '.png')
      coordinate = Coordinate.find_by(name: coordinate_name)

      unless coordinate
        puts "⚠️ コーディネート「#{coordinate_name}」が見つかりません（スキップします）"
        skip_count += 1
        next
      end

      if coordinate.image.present?
        puts "⚠️ コーディネート「#{coordinate.name}」にはすでに画像が設定されています（スキップします）"
        skip_count += 1
        next
      end

      image_path = Rails.root.join('seeds', 'images', image_filename)

      unless File.exist?(image_path)
        puts "⚠️ 画像ファイル「#{image_path}」が見つかりません（スキップします）"
        skip_count += 1
        next
      end

      # 画像を添付
      File.open(image_path) do |file|
        coordinate.image = file
      end

      if coordinate.save
        puts "✅ コーディネート「#{coordinate.name}」に画像を添付しました"
        success_count += 1
      else
        puts "❌ コーディネート「#{coordinate.name}」の保存に失敗しました: #{coordinate.errors.full_messages.join(', ')}"
        error_count += 1
      end
    end

    puts "\n🎉 画像の追加処理が完了しました！"
    puts "✅ 成功: #{success_count}件"
    puts "⚠️ スキップ: #{skip_count}件"
    puts "❌ エラー: #{error_count}件" if error_count > 0

  rescue => e
    puts "⚠️ エラーが発生しました: #{e.message}"
    puts e.backtrace.join("\n")
    raise e
  end

  def down
    # ロールバック時の処理（必要に応じて）
    puts "⚠️ ロールバックが実行されました"
    # 画像を削除する場合は以下のようにします
    # Coordinate.all.each do |coordinate|
    #   coordinate.remove_image!
    #   coordinate.save
    # end
  end
end
