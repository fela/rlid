#!/usr/bin/env ruby
module Rlid


$LOAD_PATH <<  File.expand_path("#{__FILE__}/../../../../")
require 'rlid'
require 'rlid/language_guesser/tests/test_data'



class Stats
  def initialize strings
    strings.each
  end
end

models = [SmartBayesGuesser, NaiveBayesProbabilityGuesser]

ranges = [(3..4), (5..7), (8..12)]

models.each do |cl|
  # models to train
  print "Loading data.. "
  data = TestData.new(cl.to_s)
  puts "done!"

  ranges.each do |range|
    data.stats_for(range, 9)
  end
  data.plot(cl.to_s)
end

models.each do |cl|
  # models to train
  print "Loading data.. "
  data = TestData.new(cl.to_s)
  puts "done!"

  ranges.each do |range|
    data.stats_for(range, 10, 0.95, 0.999)
  end
  data.plot(cl.to_s + "2")
end


end # module Rlid
