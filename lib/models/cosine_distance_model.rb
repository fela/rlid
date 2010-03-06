require 'models/model'
require 'common'


class FrequencyModel < NGramModel
  N = 3 # trigrams
  def initialize(string, cutoff=3000)
    super(string, N, cutoff)
  end

  def save(file)
    file.write Marshal.dump(@ngram_frequency)
  end

  def load(file)
    @ngram_frequency = Marshal.load(file.read)
  end

  def generate_model(ngram_count)
    # top ngrams (transformed into arrays)
    arrays = ngram_count.to_a.sort{|x, y| y[1] <=> x[1]}
    top = arrays[0...@cutoff] # will be kept

    tot = 0.0 # total, for normalization
    @ngram_frequency = Hash.new # key is ngram value is position
    top.each_with_index do |ngram_and_count, i|
      ngram, count = ngram_and_count
      @ngram_frequency[ngram] = count
      tot += count
    end
    
    # normalization
    @ngram_frequency.each do |ngram, count|
      @ngram_frequency[ngram] /= tot
    end
  end

  def self.filename
    # FIXME should be frequency3000
    return "cosine_distance3000"
  end

protected
  attr_reader :ngram_frequency
end

class CosineDistanceModel < FrequencyModel
  def -(other)
    if not other.is_a?(CosineDistanceModel)
      raise InvalidArgument
    end
    prod = 0
    other.ngram_frequency.each do |ngram, freq_other|
      freq_self = ngram_frequency[ngram]
      if freq_self != nil
        prod += (freq_self * freq_other)**0.2
      end
    end
    1 - prod
  end
end


