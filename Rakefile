require 'rspec/core/rake_task'
require 'rake/rdoctask'
require 'rake/clean'
require 'yard'

task :default => :spec

CLEAN.include('html','doc')

RSpec::Core::RakeTask.new do |spec| 
  spec.rspec_opts = ["--color", "--format", "nested"]
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end

# yard is the preferred doc generator for this project
YARD::Rake::YardocTask.new do |yard|
  yard.files   = ['lib/**/*.rb', 'spec/**/*.rb']
  yard.options = []
  if File.exist? '../yard-spec-plugin/lib/yard-rspec.rb'
    # prefer my local patched copy which can handle my rspec conventions better...
    yard.options.concat ['-e' '../yard-spec-plugin/lib/yard-rspec.rb']
  else
    # use the gem
    yard.options.concat ['--plugin' 'yard-rspec']
  end
end