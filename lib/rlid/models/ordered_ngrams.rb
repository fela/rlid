module Rlid

require 'rlid/models/model'
require 'rlid/common'

# a subclass should define the filename
class OrderedNGrams < NGramModel
  N = 3
  def initialize(string, cutoff=300)
    super(string, N, cutoff)
  end

  def save(file)
    @ngram_pos.each do |ngram, pos|
      file.write "#{ngram}    #{pos}\n"
    end
  end

  def load(file)
    @ngram_pos = Hash.new
    pos = 0
    file.each_line do |line|
      # keep only the first @n characters of the line
      ngram = line.gsub(/^(.{#{N}}).*\n?/, '\1')
      @ngram_pos[ngram] = pos
      pos += 1
    end
  end

  def generate_model(ngram_count)
    # top ngrams (transformed into arrays)
    top = ngram_count.to_a.sort{|x, y| y[1] <=> x[1]}[0...@cutoff]
    @ngram_pos = Hash.new # key is ngram value is position
    i = 0
    top.each {|n,| @ngram_pos[n] = i; i +=1}
  end
  
  def -(other)
    if not other.is_a?(OrderedNGrams)
      raise InvalidArgument
    end
    dist = 0
    other.ngram_pos.each do |ngram, pos_other|
      pos_self = ngram_pos[ngram]
      if pos_self != nil
        dist += (pos_self - pos_other).abs
      else
        dist += @cutoff # max distance
      end
    end
    dist
  end

protected
  attr_reader :ngram_pos
end


class NGramsKDE < OrderedNGrams
  def self.filename
    return "3grams300kde"
  end
end

class NGrams300 < OrderedNGrams
  def self.filename
    return "3grams300"
  end
end

class NGrams800 < OrderedNGrams
  def initialize(string)
    super(string, 800)
  end
  def self.filename
    return "3grams800"
  end
end

class NGrams3000 < OrderedNGrams
  def initialize(string)
    super(string, 3000)
  end
  def self.filename
    return "3grams3000"
  end
end


class NGrams4000 < OrderedNGrams
  def initialize(string)
    super(string, 4000)
  end
  def self.filename
    return "3grams4000"
  end
end


end # module Rlid
