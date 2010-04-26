module Rlid

require 'rlid/language_guesser/language_guesser'

class ModelDistanceGuesser < LanguageGuesser
  def initialize(model_class)
    @model_class = model_class
    print "Loading models.. "
    @language_models = model_class.language_models
    @name = "Model Distance"
    puts "Done!"
  end

  def guess_language(string)
    model = @model_class.new(string)
    min_language = min_distance = nil
    @language_models.each do |lang, lang_model|
      dist = lang_model - model
      if min_distance == nil or dist < min_distance
        min_distance = dist
        min_language = lang
      end
    end
    min_language
  end
end


#class OnlineGuesser < ModelDistanceGuesser
#  def guess_language(string)
#    min_language = min_distance = nil
#    @language_models.each do |lang, lang_model|
#      dist = lang_model.distance_from(string)
#      if min_distance == nil or dist < min_distance
#        min_distance = dist
#        min_language = lang
#      end
#    end
#    min_language
#  end
#end

end # module Rlid
