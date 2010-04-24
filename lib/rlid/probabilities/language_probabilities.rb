require 'rlid/common'

class Percentage
  def initialize value
    @value = value
  end

  def to_s
    if @value <= 0.98
      return "%.2g" % (@value * 100)
    else
      complement = 1.0 - @value
      # complement =
      log = -Math.log10(complement).ceil
      digits = log - 1
      res = "%.#{digits}f" % (@value * 100)
      last = -1
      while res[last] == ?9
        digits += 1
        res = "%.#{digits}f" % (@value * 100)
      end
      return res
    end
  end

  def to_f
    @value
  end
end







class LanguageProbabilities
  MAX_OUTPUT = 3

  def initialize(args={})
    @percentage = Hash.new(0)
    args.each do |languages, percentage|
      add(languages, percentage)
    end
  end

  def random_language
    r = rand
    sum = 0
    @percentage.each do |language, perc|
      sum += perc
      return language if sum > r
      #puts "#{sum}(#{r})"
    end
    warn "rounding error!! (sum is not 1!!)"
    @percentage.keys.first
  end

  def to_s
    sorted[0...MAX_OUTPUT].map do |x|
      # calculate the digits
      formatted_perc = Percentage.new(x[PERC]).to_s
      "#{x[LANG]}(#{formatted_perc})"
    end.join(" : ")
  end

  def first
    sorted.first[LANG]
  end

  def *(other)
    if not other.is_a? LanguageProbabilities
      p other.inspect
      raise InvalidArgument.new(other)
    end
    res = LanguageProbabilities.new()
    @percentage.each_key do |lang|
      res.percentage[lang] = percentage[lang] * other.percentage[lang]
    end
    res.normalize
    res
  end

private
  def add(languages, perc)
    if perc < 0 or perc > 1
      perc = perc.round
    end
    languages = [languages] if not languages.is_a? Array
    perc = perc.to_f / languages.size
    languages.each {|l| @percentage[l] = perc}
  end

#  def add_remainder
#    languages = LANGUAGES - @percentage.keys
#    perc = 1.0 - sum
#    add(languages, perc)
#  end

protected
  # indexes
  LANG = 0
  PERC = 1

  def random_language_and_delete
    l = random_language
    @percentage.delete(l)
    normalize
    l
  end

  def normalize
    tot = sum
    return if tot == 0
    @percentage.each_key do |key|
      @percentage[key] /= tot
    end
  end

  def sum
    @percentage.values.inject(0){|s, v| s + v}
  end

  def sorted
    @percentage.to_a.sort!{|x,y| y[PERC] <=> x[PERC]}
  end

  attr_accessor :percentage
end





class TestProbabilities < LanguageProbabilities
  def initialize(lang, perc_lang=0.8, perc_lang_and_common=0.98)
    @lang = lang
    @perc_lang = perc_lang
    common = COMMON_LANGUAGES - [lang]
    other = LANGUAGES - COMMON_LANGUAGES - [lang]
    @common_size = common.size
    @other_size = other.size
    @perc_common = perc_lang_and_common - perc_lang
    @perc_other = 1 - perc_lang_and_common
    super(lang => @perc_lang, common => @perc_common, other => @perc_other)
  end

  def random_permutation
    lang = random_language
    return self if lang == @lang

    probs = probabilities

    top_lang = probs.first

    probs.percentage[lang], probs.percentage[top_lang] =
      probs.percentage[top_lang], probs.percentage[lang]

    probs
  end

#    common = []
#    @common_size.times do
#      common << probs.random_language_and_delete
#    end
#    other = []
#    @other_size.times do
#      other << probs.random_language_and_delete
#    end
#
#    LanguageProbabilities.new(
#      lang => @perc_lang,
#      common => @perc_common,
#      other => @perc_other)

  def probabilities
    LanguageProbabilities.new(percentage)
  end
end

#class Array
#  def sum
#    inject(0) {|s,v| s+v}
#  end
#end
#x = TestProbabilities.new(:eng)
#res = Hash.new(0)
#100000.times{res[x.random_permutation.random_language] += 1}
#res.each{|k,v| puts "#{k}: #{v/1000.0}"}
#
#res.values.select{|x| x > 1000 and x < 10000}.sum / 1000.0
#res.values.select{|x| x > 10000}.sum / 1000.0
#res.values.select{|x| x < 1000}.sum / 1000.0