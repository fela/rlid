require 'language_detector/model_distance_guesser'
require 'trigrams/trigram_model'
require 'language_detector/tester'

#guesser1 = ModelDistanceGuesser.new(NGramsKDE)
#guesser2 = ModelDistanceGuesser.new(NGrams300)
#
#str = "niks niet"
#puts guesser1.guess_language(str)
#puts guesser2.guess_language(str)



res1 = Tester.test(NGramsKDE)

res1.keys.sort.each do |key|
  puts "#{key} #{res1[key] / 22}"
end

res2 = Tester.test(NGrams300)

res2.keys.sort.each do |key|
  puts "#{key} #{res2[key] / 22}"
end

puts ">> improvement <<"
tot = 0
res1.keys.sort.each do |key|
  improvement = (res2[key] - res1[key]) / 22 * 100
  tot += improvement
  puts "#{key} #{improvement}"
end

puts "on avarage: #{tot/res1.keys.size}"
