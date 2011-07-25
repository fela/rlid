#!/usr/bin/env ruby1.9.1

module Rlid

$LOAD_PATH <<  File.expand_path("#{__FILE__}/../../../")
require 'rlid/models/naive_bayes_models'

NaiveBayesModels.generate_models
NaiveBayesModels.generate_models("bigrams", 2)

end # module Rlid
