#!/usr/bin/env ruby1.9.1

require 'rlid/language_guesser/tests/test'
require 'rlid/language_guesser/model_distance_guesser'
require 'rlid/models/ordered_ngrams'
require 'rlid/common'

guesser1 = ModelDistanceGuesser.new(NGramsKDE)
guesser2 = ModelDistanceGuesser.new(NGrams300)
guesser1.name = "TextCat"
guesser2.name = "Subtitles"
t = Test.new
#t.test_length = 3000
t.languages = [:eng]
t.filename = "novel_test"
t.guessers = [guesser2, guesser1]

result = t.execute
result.xrange = (7..60)
result.title = "Novel"
result.plot("corpus_novel_eng")
