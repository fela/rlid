
Gem::Specification.new do |s|
  s.name = 'rlid'
  s.version = '0.1.3'
  #s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Language identification library'
  s.description = "Language identification library specialized in " +
                  "guessing the language of short strings."
  s.author = 'Fela Winkelmolen'
  s.email = 'fela.kde@gmail.com'
  s.homepage = 'https://github.com/fela/rlid'
  s.license = 'MIT'
  s.files = Dir.glob("lib/*.rb") +
            Dir.glob("lib/rlid/*.rb") +
            Dir.glob("lib/rlid/{language_guesser,models,probabilities}/*.rb") +
            Dir.glob("data/naive_bayes_models")
  s.require_path = "lib"
  #s.executables = ['your_executable_here']
  #s.bindir = "bin"
end
