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
    Rlid.tmp_methods[self] = all_methods
  end

  def all_methods
    public_methods + private_methods + protected_methods
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

  def fff
    puts "fff"
  end
  protected
  def function(abc)
    abc
  end
end

module Rlid
  tmp_methods.each do |cl, old_methods|
    new_methods = cl.all_methods
    to_be_removed = new_methods - old_methods
    puts old_methods.include? :function
    puts new_methods.include? :function
    puts cl.protected_methods
    to_be_removed.each do |m|
      puts "#{cl}.#{m} "
    end
  end
end

puts RUBY_VERSION


#irb self