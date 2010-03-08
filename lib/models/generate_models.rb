#!/usr/bin/env ruby1.9.1

require 'common'
require 'models/ordered_ngrams'
require 'models/cosine_distance_model'

# models to train
MODELS = [CosineDistanceModel]

MODELS.each do |model|
puts "training #{model}"
Language.each_2files('corpus', model.filename, 'r', 'w') do |corpus, file, l|
  puts "learning #{l}.."
  model.new(corpus.read).save file
end
end

puts ">>  Successfully trained!!  <<"
