#!/usr/bin/env ruby1.9.1

require 'language_guesser/tests/test'
require 'language_guesser/model_distance_guesser'
require 'models/ordered_ngrams'
require 'common'

guesser = ModelDistanceGuesser.new(NGramsKDE)
guesser.name = "TextCat"
t = Test.new
t.test_length = 25000
t.languages = [:dut, :eng, :ita, :por, :fre, :ger]
t.filename = "test_data"
t.guessers = [guesser]

result = t.execute
result.plot("accuracy")
