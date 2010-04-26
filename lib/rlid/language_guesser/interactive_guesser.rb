#!/usr/bin/env ruby1.9.1
module Rlid

require 'rlid/language_guesser/model_distance_guesser'
require 'rlid/models/cosine_distance_model'
require 'rlid/language_guesser/naive_bayes_guesser'

#guesser = ModelDistanceGuesser.new(CosineDistanceModel)
#guesser = OnlineGuesser.new(NaiveBayesModel)
guesser = NaiveBayesProbabilityGuesser.new
#guesser = NaiveBayesPriorGuesser.new

loop do
  print "> "
  puts guesser.guess_language(gets).to_s
end

end # module Rlid
