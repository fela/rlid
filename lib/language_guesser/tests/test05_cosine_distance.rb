#!/usr/bin/env ruby1.9.1

require 'language_guesser/tests/test'
require 'language_guesser/model_distance_guesser'
require 'models/ordered_ngrams'
require 'models/cosine_distance_model'
require 'common'

guesser1 = ModelDistanceGuesser.new(NGrams3000)
guesser2 = ModelDistanceGuesser.new(CosineDistanceModel)
guesser1.name = "rank order"
guesser2.name = "cosine distance"
t = Test.new
t.languages = [:dut, :eng, :ita, :por, :fre, :ger]
t.test_length = 2500
t.filename = "test_data"
t.guessers = [guesser1, guesser2]

result = t.execute
result.plot("cosine_distance")
