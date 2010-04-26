module Rlid

class LanguageGuesser
  attr_accessor :name
  def initialize
    @name = "unknown"
  end

  def guess_language(string)
    raise "#{self.class} should be subclassed"
    string # never called, supresses unused variable warning
  end
end

end # module Rlid
