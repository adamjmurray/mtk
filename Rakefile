require 'rspec/core/rake_task'
require 'rake/clean'
require 'yard'

task :default => :spec

CLEAN.include('html','doc') # clean and clobber do the same thing for now

desc "Run RSpec tests with full output"
RSpec::Core::RakeTask.new do |spec| 
  spec.rspec_opts = ["--color", "--format", "nested"]
end

namespace :spec do

  desc "Run RSpecs tests with summary output and fast failure"
  RSpec::Core::RakeTask.new(:fast) do |spec|
    spec.rspec_opts = ["--color", "--fail-fast"]
  end

  desc "Run RSpecs tests on mutiple versions of Ruby: 1.8.7, 1.9.2, JRuby 1.5.6, and JRuby 1.6.2"
  task :xversion do
    fail unless system("rvm 1.8.7,1.9.2,jruby-1.5.6,jruby-1.6.2 rake -f #{__FILE__} spec:fast")
  end

end


YARD::Rake::YardocTask.new do |yard|
  yard.files   = ['lib/**/*.rb', 'spec/**/*.rb']
  yard.options = []
  if File.exist? '../yard-spec-plugin/lib/yard-rspec.rb'
    # prefer my local patched copy which can handle my rspec conventions better...
    yard.options.concat ['-e' '../yard-spec-plugin/lib/yard-rspec.rb']
  else
    # use the gem
    yard.options.concat ['-e' 'yard-rspec']
  end
end
