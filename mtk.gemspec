Gem::Specification.new do |gem|
  gem.name        = 'mtk'
  gem.version     = '0.0.3'

  gem.summary     = 'Music Tool Kit for Ruby'
  gem.author      = 'Adam Murray'
  gem.email       = 'adam@compusition.com'
  gem.homepage    = 'http://github.com/adamjmurray/mtk'

  gem.files       = Dir['Rakefile', '*.md', 'LICENSE.txt', '.yardopts', 'bin/*', 'examples/*', 'lib/**/*', 'spec/**/*']
  gem.bindir      = 'bin'
  gem.executables = ['mtk']

  gem.add_dependency('citrus', '>= 2.4')
end