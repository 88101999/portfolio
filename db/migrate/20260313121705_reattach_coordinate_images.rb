class ReattachCoordinateImages < ActiveRecord::Migration[7.2]
  def up
    # 既存の画像を削除（Cloudinary から削除される）
    puts "🗑️ 既存の画像を削除しています..."
    Coordinate.find_each do |coordinate|
      coordinate.image.purge if coordinate.image.attached?
    end

    # 画像を再アタッチ
    image_files = Dir.glob(Rails.root.join('db', 'seeds', 'images', '*.png')).map { |path| File.basename(path) }
    
    puts "📁 見つかった画像ファイル: #{image_files.count}件"
    
    success_count = 0
    skip_count = 0
    
    image_files.each do |image_filename|
      coordinate_name = File.basename(image_filename, '.png')
      coordinate = Coordinate.find_by(name: coordinate_name)

      unless coordinate
        puts "⚠️ コーディネート「#{coordinate_name}」が見つかりません（スキップします）"
        skip_count += 1
        next
      end

      image_path = Rails.root.join('db', 'seeds', 'images', image_filename)

      unless File.exist?(image_path)
        puts "⚠️ 画像ファイル「#{image_path}」が見つかりません（スキップします）"
        skip_count += 1
        next
      end

      File.open(image_path) do |file|
        coordinate.image.attach(
          io: file,
          filename: image_filename,
          content_type: 'image/png'
        )
      end

      if coordinate.save
        puts "✅ コーディネート「#{coordinate.name}」に画像を添付しました"
        success_count += 1
      else
        puts "❌ コーディネート「#{coordinate.name}」の保存に失敗しました: #{coordinate.errors.full_messages.join(', ')}"
        skip_count += 1
      end
    end
    
    puts "\n🎉 画像の追加処理が完了しました！"
    puts "✅ 成功: #{success_count}件"
    puts "⚠️ スキップ: #{skip_count}件"
  end
  
  def down
    # ロールバック時は何もしない
    puts "⚠️ ロールバックが実行されました"
  end
end