# generated by NetBeans 6.8
 

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
#require 'spec/rake/spectask'

spec = Gem::Specification.new do |s|
  s.name = 'rlid'
  s.version = '0.1.1'
  s.required_ruby_version = '>= 1.9.1'
  s.has_rdoc = false
  #s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Language identification library'
  s.description = "Language identification library specialized in " +
                  "guessing the language of short strings."
  s.author = 'Fela Winkelmolen'
  s.email = 'fela.kde@gmail.com'
  s.homepage = 'https://github.com/fela/rlid'
  #s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.files = Dir.glob("lib/*.rb") +
            Dir.glob("lib/rlid/*.rb") +
            Dir.glob("lib/rlid/{language_guesser,models,probabilities}/*.rb") +
            Dir.glob("data/naive_bayes_models")
  s.require_path = "lib"
  #s.executables = ['your_executable_here']
  #s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "languageid Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

#Spec::Rake::SpecTask.new do |t|
#  t.spec_files = FileList['spec/**/*.rb']
#  t.libs << Dir["lib"]
#end
