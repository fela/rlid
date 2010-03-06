#!/usr/bin/env ruby1.9.1

require 'language_guesser/tests/test'
require 'language_guesser/model_distance_guesser'
require 'models/ordered_ngrams'
require 'common'

guesser1 = ModelDistanceGuesser.new(NGramsKDE)
guesser2 = ModelDistanceGuesser.new(NGrams300)
guesser1.name = "TextCat"
guesser2.name = "Subtitles"
t = Test.new
t.languages = [:eng]
t.filename = "novel_test"
t.guessers = [guesser1, guesser2]

result = t.execute
result.title = "Novel"
result.plot("corpus_novel_eng")
