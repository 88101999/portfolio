class RemoveOldQuestions < ActiveRecord::Migration[7.2]
  def up
    old_question_texts = [
      "あなたの性別を教えてください",
      "どんなシーンで着ますか？",
      "どんなジャンルが好きですか？"
    ]

    old_questions = Question.where(text: old_question_texts)
    old_question_ids = old_questions.pluck(:id)

    if old_question_ids.any?
      old_option_ids = Option.where(question_id: old_question_ids).pluck(:id)

      if old_option_ids.any?
        CoordinateOption.where(option_id: old_option_ids).delete_all
        puts "✅ 関連する CoordinateOption #{CoordinateOption.where(option_id: old_option_ids).count} 件を削除しました"
      end

      Answer.where(question_id: old_question_ids).delete_all
      puts "✅ 関連する Answer を削除しました"

      Option.where(question_id: old_question_ids).delete_all
      puts "✅ 関連する Option を削除しました"

      Question.where(id: old_question_ids).delete_all
      puts "✅ 古い質問 #{old_question_ids.count} 件を削除しました"
    else
      puts "⚠️ 削除対象の古い質問が見つかりませんでした"
    end
  rescue => e
    puts "⚠️ エラーが発生しました: #{e.message}"
    raise e
  end

  def down
    puts "⚠️ この操作はロールバックできません"
  end
end
