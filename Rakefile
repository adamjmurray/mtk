require 'rspec/core/rake_task'
require 'rake/clean'
require 'yard'

SUPPORTED_RUBIES = %w[ 1.8.7  1.9.2  jruby-1.5.6  jruby-1.6.3 ]

task :default => :spec

CLEAN.include('html','doc') # clean and clobber do the same thing for now

desc "Run RSpec tests with full output"
RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = ["--color", "--format", "nested"]
  if ARGV[1]
    # only run specs with filenames starting with the command line argument
    spec.pattern = "spec/**/#{ARGV[1]}*"
  end
end


namespace :gem do
  desc "Install gems for supported versions of Ruby: #{SUPPORTED_RUBIES.join ', '}"
  task :install do
    fail unless system("rvm #{SUPPORTED_RUBIES.join ','} gem install --no-rdoc --no-ri rake rspec yard midilib citrus")
  end
end



namespace :spec do
  desc "Run RSpecs tests with summary output and fast failure"
  RSpec::Core::RakeTask.new(:fast) do |spec|
    spec.rspec_opts = ["--color", "--fail-fast"]
  end

  desc "Run RSpecs tests on all supported versions of Ruby: #{SUPPORTED_RUBIES.join ', '}"
  task :all do
    fail unless system("rvm #{SUPPORTED_RUBIES.join ','} rake -f #{__FILE__} spec:fast")
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
