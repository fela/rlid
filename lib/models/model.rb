# abstract class

class Model
  def initialize string
    raise "#{self.class} should be subclassed"
    string # never called, supresses unused variable warning
  end
end



# in subclasses generate_model filename, load and save should be implemented
class NGramModel < Model
  def initialize(string=nil, n=3, cutoff=300)
    @n = n
    @cutoff = cutoff

    if string == nil then return end

    # ngrams and count of each
    ngram_count = Hash.new(0)

    string.each_ngram(@n) do |ngram|
      ngram_count[ngram] += 1
    end

    generate_model(ngram_count)
  end


  def self.language_models
    if not defined?(filename)
      raise "#{self.class} should be subclassed!"
    end
    res = Hash.new
    Language.each_file(filename) do |file, lang|
      model = self.new(nil)
      model.load(file)
      res[lang] = model
    end
    res
  end

protected
  # should be implemented in the subclass
  # ngram_count is a hash: ngram => count
  def generate_model(ngram_count)
    raise "#{self.class} should be subclassed"
    ngram_count # never called, supresses unused variable warning
  end
end