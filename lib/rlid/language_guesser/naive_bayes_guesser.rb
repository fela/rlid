module Rlid

require 'rlid/language_guesser/language_guesser'
require 'rlid/models/naive_bayes_models'
require 'rlid/probabilities/language_probabilities'

class NaiveBayesGuesser < LanguageGuesser
  def initialize(default=1)
    print "Naive Bayes: loading models.."
    @models = NaiveBayesModels.load
    @models.default_count = default
    @name = "Naive Bayes"
    puts " Done!"
  end
  
  def guess_language(string)
    max_prob = 0.0
    best_language = nil
    @models.probabilities(string) do |lang, prob|
      if prob > max_prob
        max_prob = prob
        best_language = lang
      end
    end
    best_language
  end
end

class NaiveBayesProbabilityGuesser < NaiveBayesGuesser
  def guess_language(string)
    results = {}
    tot = 0.0 # for normalization
    @models.probabilities(string) do |lang, p|
      size = string.preprocess(3).size
      long = Math.log(1 + size)
      # higher means lower
      short = 1
      exp = short/long
      prob = p**exp
      results[lang] = prob
      tot += prob
    end
    # normalize
    results.each_key do |k|
      results[k] /= tot if tot != 0
    end

    LanguageProbabilities.new(results)
  end
end

class SmartBayesGuesser < LanguageGuesser
  def initialize(default=1)
    #print "Smart Bayes: loading models.."
    @models = SmartBayesModels.new
    #puts " Done!"
  end
  def guess_language(string)
    results = @models.probabilities(string)
    results.delete :nnn
    tot = results.values.inject(0.0){|s,x| s+x}
    results.each_key do |lang|
      results[lang] /= tot
    end
    LanguageProbabilities.new(results)
  end
end


class NaiveBayesPriorGuesser < NaiveBayesProbabilityGuesser
  def initialize(prior=TestProbabilities.new(:eng))
    if not prior.is_a?(LanguageProbabilities)
      raise InvalidArgument
    end
    @prior = prior
    super()
  end

  def set_prior(prior)
    @prior = prior
  end

  alias :super_guess_language :guess_language
  def guess_language(string)
    conditional = super_guess_language(string)
    (conditional * @prior).first
  end
end

end # module Rlid
