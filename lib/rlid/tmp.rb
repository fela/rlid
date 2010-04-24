module Rlid
  def self.tmp_methods
    @@tmp_methods
  end
  def self.tmp_methods= (val)
    @@tmp_methods = val
  end
  @@tmp_methods = {}
end

class Module
  def rlid_tmp_methods
    Rlid.tmp_methods[self] = public_methods + private_methods
  end
end

class C
  def c1
    puts "c1"
  end

  def c2
    "c2"
  end

  rlid_tmp_methods

  protected
  def function(abc)
    abc
  end
end

module Rlid
  tmp_methods.each do |cl, old_methods|
    new_methods = self.public_methods + self.private_methods
    to_be_removed = new_methods - old_methods
    to_be_removed.each do |m|
      puts "#{cl}.#{m} "
    end
  end
end