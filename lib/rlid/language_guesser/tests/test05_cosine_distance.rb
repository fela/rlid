#!/usr/bin/env ruby1.9.1

require 'rlid/language_guesser/tests/test'
require 'rlid/language_guesser/model_distance_guesser'
require 'rlid/models/ordered_ngrams'
require 'rlid/models/cosine_distance_model'
require 'rlid/common'

guesser1 = ModelDistanceGuesser.new(NGrams3000)
guesser2 = ModelDistanceGuesser.new(CosineDistanceModel)
guesser1.name = "ROC 3000"
guesser2.name = "cosine distance 3000"
t = Test.new
t.languages = [:dut, :eng, :ita, :por, :fre, :ger]
t.test_length = 25000
t.filename = "test_data"
t.guessers = [guesser2, guesser1]

result = t.execute
result.plot("cosine_distance")
