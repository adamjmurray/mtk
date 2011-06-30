Gem::Specification.new do |gem|
  gem.name        = 'mtk'
  gem.version     = '0.0.1'

  gem.summary     = 'Music ToolKit for Ruby'
  gem.author      = 'Adam Murray'
  gem.email       = 'adam@compusition.com'
  gem.homepage    = 'http://github.com/adamjmurray/mtk'

  gem.files = Dir['Rakefile', 'README.md', 'LICENSE.txt',
                  'lib/**/*.rb', 'lib/**/*.citrus',
                  'spec/**/*.rb', 'spec/**/*.mid',
                  'examples/**/*.rb']
end