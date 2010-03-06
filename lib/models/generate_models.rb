#!/usr/bin/env ruby1.9.1

require 'common'
require 'models/ordered_ngrams'
require 'models/cosine_distance_model'

MODEL = NGrams4000

Language.each_2files('corpus', MODEL.filename, 'r', 'w') do |corpus, model, l|
  puts "learning #{l}.."
  MODEL.new(corpus.read).save model
end

puts ">>  Successfully trained!!  <<"
