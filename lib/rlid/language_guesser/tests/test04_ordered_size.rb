#!/usr/bin/env ruby1.9.1

require 'rlid/language_guesser/tests/test'
require 'rlid/language_guesser/model_distance_guesser'
require 'rlid/models/ordered_ngrams'
require 'rlid/common'

guesser1 = ModelDistanceGuesser.new(NGrams300)
guesser2 = ModelDistanceGuesser.new(NGrams800)
guesser3 = ModelDistanceGuesser.new(NGrams3000)
guesser4 = ModelDistanceGuesser.new(NGrams4000)
guesser1.name = "300"
guesser2.name = "800"
guesser3.name = "3000"
guesser4.name = "4000"

t = Test.new
t.test_length = 25000
t.languages = COMMON_LANGUAGES
t.filename = "test_data"
t.guessers = [guesser4, guesser3, guesser2, guesser1]

result = t.execute
result.title = "Subtitles"
result.plot("ordered_size")

#######################################################

t.test_length = -1 # no limit
#t.test_length = 5000
t.languages = [:eng, :por]
t.filename = "news_test"
result = t.execute
result.xrange = (5..60)
result.title = "News"
result.plot("ordered_size_news")
