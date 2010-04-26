module Rlid

DATA_DIRECTORY =  File.expand_path("../data")

class Language
  CODES = [
    [:en, :eng, 'English'],
    [:es, :spa, 'Spanish'],
    [:de, :ger, 'German'],
    [:fr, :fre, 'French'],
    [:it, :ita, 'Italian'],
    [:pt, :por, 'Portoguese'],
    [:nl, :dut, 'Dutch'],
    [:pl, :pol, 'Polish'],
    [:id, :ind, 'Malay/Indonesian'],
    [:sv, :swe, 'Swedish'],
    [:tr, :tur, 'Turkish'],
    [:vi, :vie, 'Vietnamese'],
    [:ro, :rum, 'Romanian'],
    [:cs, :cze, 'Czech'],
    [:da, :dan, 'Danish'],
    [:fi, :fin, 'Finnish'],
    [:hu, :hun, 'Hungarian'],
    [:el, :ell, 'Greek'],
    [:ca, :cat, 'Catalan'],
    [:no, :nor, 'Norvegian'],
    [:sk, :slo, 'Slovak'],
    [:is, :ice, 'Icelandic'],
    #[:ff, :fff], # fdakjlfdaj;
  ]

  # indexes
  CODE2 = 0
  CODE3 = 1
  NAME = 3
  NO_LANGUAGE_CODE = :nnn

  def Language.all_codes2
    CODES.map{|c| c[CODE2]}
  end

  def Language.all_codes3
    CODES.map{|c| c[CODE3]}
  end


  # enters each directory and passes the directory name to the block
#  def Language.each_dir
#    all_codes2.each do |lang_code|
#      Dir.chdir("#{DATA_DIRECTORY}/#{lang_code}") do |dir|
#        yield dir
#      end
#    end
#  end

  def Language.code2to3 code2
    begin
      CODES.select{|x| x[CODE2].to_s == code2.to_s}[0][CODE3]
    rescue
      nil
    end
  end

  def Language.name_of(code)
    index = all_codes3.index(code) or all_codes2.index(code)
    CODES[index][NAME]
  end

  def Language.each_file(filename, mode="r")
    all_codes3.each do |lang_code|
      filepath = "#{DATA_DIRECTORY}/#{lang_code}/#{filename}"
      File.open(filepath, mode) do |file|
        yield file, lang_code
      end
    end
  end

  def Language.each_2files(filename1, filename2, mode1="r", mode2="r")
    all_codes3.each do |lang_code|
      filepath1 = "#{DATA_DIRECTORY}/#{lang_code}/#{filename1}"
      filepath2 = "#{DATA_DIRECTORY}/#{lang_code}/#{filename2}"
      File.open(filepath1, mode1) do |file1|
      File.open(filepath2, mode2) do |file2|
        yield file1, file2, lang_code
      end
      end
    end
  end
end

LANGUAGES = Language.all_codes3
COMMON_LANGUAGES = [:dut, :eng, :ita, :por, :fre, :ger]


# for ngrams

end # module Rlid


# add methods to String
class String
  def each_ngram(n=3)
    string = preprocess(n)
    string.chars.each_cons(n) do |chars|
      yield chars.join
    end
  end

#private
  def preprocess(n)
    string = self.dup

    # remove spaces at the ends
    string.gsub!(/\A\s+/, '')
    string.gsub!(/\s+\Z/, '')

    # remove non alphabetic characters
    string.gsub!(/[^[:alpha:]'\n]/, ' ')
    # substitute newlines with ||
    string.gsub!(/\s*\n\s*/, '|'*(n-1))
    string.gsub!(/\s+/, ' ')
    string.downcase!

    padding = "|" * (n-1)

    if string.size == 1
      string = "|" + string + " "
    elsif string.size == 1
      string = padding + string + " "
    else
      string = padding + string + padding
    end
    string
  end
end

