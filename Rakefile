require 'rspec/core/rake_task'
require 'rake/rdoctask'

task :default => :spec

RSpec::Core::RakeTask.new do |t| 
  t.rspec_opts = ["--color", "--format", "nested"]
end

Rake::RDocTask.new do |rdoc|
  rdoc.title    = "Kreet: another sequencing project"
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end