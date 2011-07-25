#!/usr/bin/env ruby1.9.1

module Rlid

$LOAD_PATH <<  File.expand_path("#{__FILE__}/../../../../")
require 'rlid/language_guesser/tests/test'
require 'rlid/language_guesser/model_distance_guesser'
require 'rlid/models/ordered_ngrams'
require 'rlid/common'

guesser = ModelDistanceGuesser.new(NGramsKDE)
guesser.name = "TextCat"
t = Test.new
t.test_length = 2500
t.languages = COMMON_LANGUAGES
t.filename = "test_data"
t.guessers = [guesser]

result = t.execute
result.xrange = (5..60)
result.plot("accuracy")

end
