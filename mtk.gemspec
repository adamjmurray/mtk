Gem::Specification.new do |gem|
  gem.name        = 'mtk'
  gem.version     = '0.0.3.2'

  gem.summary     = 'Music Tool Kit for Ruby'
  gem.description = 'A music library and domain-specific language for generating music via MIDI.'
  gem.author      = 'Adam Murray'
  gem.email       = 'adam@compusition.com'
  gem.homepage    = 'http://github.com/adamjmurray/mtk'

  gem.files       = Dir['Rakefile', '*.md', 'LICENSE.txt', '.yardopts', 'bin/*', 'examples/*', 'lib/**/*', 'spec/**/*']
  gem.bindir      = 'bin'
  gem.executables = ['mtk']

  gem.add_dependency 'citrus', '>= 2.4'
  gem.add_dependency 'midilib', '~> 2.0'
  gem.add_dependency 'gamelan', '~> 0.3'

  # additional platform-specific dependencies for MIDI I/O are handled in ext/mkrf_conf.rb
  gem.extensions = ['ext/mkrf_conf.rb']
end