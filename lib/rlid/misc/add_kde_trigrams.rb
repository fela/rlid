require 'fileutils'

require 'rlid/common'

# directory containing the kde trigrams
KDE_DIR = '/home/kde-devel/sonnet-multilang/unicode/data/trigrams'

languages_kde = []

Dir.new(KDE_DIR).each do |file|
  lang_code = Language.code2to3(file)
  if not lang_code then next end # not used language

  languages_kde << lang_code

  orig = "#{KDE_DIR}/#{file}"
  dest = "#{DATA_DIRECTORY}/#{lang_code}/3grams300kde"

  puts "moving #{lang_code}"
  FileUtils.cp(orig, dest)
end

puts "not found:"
p LANGUAGES - languages_kde
