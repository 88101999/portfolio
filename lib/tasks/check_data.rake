namespace :db do
  desc "Check production data"
  task check_data: :environment do
    puts "=== Question Count ==="
    puts Question.count
    
    puts "\n=== Option Count ==="
    puts Option.count
    
    puts "\n=== All Questions ==="
    Question.all.each do |q|
      puts "ID: #{q.id}, Text: #{q.text}"
    end
    
    puts "\n=== All Options ==="
    Option.all.each do |o|
      puts "ID: #{o.id}, Name: #{o.name}, Question ID: #{o.question_id}"
    end
  end
end