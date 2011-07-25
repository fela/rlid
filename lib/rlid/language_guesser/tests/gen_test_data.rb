#!/usr/bin/env ruby
module Rlid


$LOAD_PATH <<  File.expand_path("#{__FILE__}/../../../../")
require 'rlid/language_guesser/naive_bayes_guesser'
require 'rlid/language_guesser/tests/test_data'

#TestData.gen_data(NaiveBayesProbabilityGuesser)
TestData.gen_data(SmartBayesGuesser)

end # module Rlid
