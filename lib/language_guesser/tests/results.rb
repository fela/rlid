#class Hash
#  # overloads the sum operator
#  # sums the values having the same key
#  def +(other)
#    res = self.dup
#    other.each do |key, value|
#      res[key] += value
#    end
#    res
#  end
#end

require 'gnuplot'
require 'common'
require 'language_guesser/tests/test'



class Array
  # (1..6).to_a.combine(2) => [1.2, 3.5, 5.5]
  def combine(n)
    res = []
    each_slice(n) {|x| res << x.avg}
    res
  end

  def avg
    sum.to_f / size
  end

  def sum
    inject(0) {|x, y| x + y }
  end
end





class Results
  attr_accessor :title, :xrange, :yrange

  # results is a hash: num of chars => accuracy
  def initialize(name=nil, results=nil)
    @results = Hash.new
    @results[name] = results if name
    @xrange = (Test::MIN_CHARS..Test::MAX_CHARS)
    @yrange = (0.3..1)
  end

  def <<(other)
    other.results.each do |name, hash|
      @results[name] = hash
    end
  end

  def plot(filename)
    # filename with complete path
    file = "#{DATA_DIRECTORY}/test_results/#{filename}.eps"
    Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
      plot.xrange "[#{xrange.first}:#{xrange.last}]"
      plot.yrange "[#{yrange.first}:#{yrange.last}]"
      plot.title title if title
      plot.ylabel "accuracy"
      plot.xlabel "input length"
      plot.output file
      plot.term "postscript eps enhanced"
      plot.key "right bottom" # position of the labels

      plot.data = plot_data
    end
    end

    puts "== file saved to #{file} =="
  end

private
  def plot_data
    data = []
    @results.each do |name, hash|
      # coverto to array and sort
      combine_size = 3 # combine consecutive data...
      a = hash.to_a.sort{|x, y| x[0] <=> y[0]}
      x = a.map{|v| v[0]}.combine(combine_size)
      y = a.map{|v| v[1]}.combine(combine_size)
      data << Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines"
        #ds.linewidth = 4
        ds.title = name if not name.empty?
      end
    end
    data
  end

#  def +(other)
#    res = Results.new
#    if results.keys != other.results.keys
#      raise InvalidArgument
#    end
#
#    @results.each do |name, hash|
#      # to be finished..
#    end
#  end

protected
  attr_accessor :results
end
