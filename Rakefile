require 'rspec/core/rake_task'
require 'rake/clean'

SUPPORTED_RUBIES = %w[ 1.9.3  jruby-1.6.7 ]

task :default => :test

CLEAN.include('html','doc','coverage.data','coverage') # clean and clobber do the same thing for now

desc "Run RSpec tests with full output"
RSpec::Core::RakeTask.new('test') do |spec|
  spec.rspec_opts = ["--color", "--format", "nested"]
  if ARGV[1]
    # only run specs with filenames starting with the command line argument
    spec.pattern = "spec/**/#{ARGV[1]}*"
  end
end


namespace :gem do
  desc "Install gems for supported versions of Ruby: #{SUPPORTED_RUBIES.join ', '}"
  task :install do
    fail unless system("rvm #{SUPPORTED_RUBIES.join ','} do bundle install")
  end
end


namespace :test do
  desc "Run RSpec tests with summary output and fast failure"
  RSpec::Core::RakeTask.new(:fast) do |spec|
    spec.rspec_opts = ["--color", "--fail-fast"]
  end

  desc "Run RSpec tests and generate a coverage report"
  if RUBY_PLATFORM == "java"
    task :cov do |t|
      fail "#{t} task is not compatible with JRuby. Use Ruby 1.9 instead."
    end
  else
    RSpec::Core::RakeTask.new(:cov) do |spec|
      spec.rspec_opts = ["--color", "-r", "#{File.dirname __FILE__}/spec/spec_coverage.rb"]
    end
  end

  desc "Profile RSpec tests and report 10 slowest"
  RSpec::Core::RakeTask.new(:prof) do |spec|
    spec.rspec_opts = ["--color", "-p"]
  end

  desc "Run RSpec tests on all supported versions of Ruby: #{SUPPORTED_RUBIES.join ', '}"
  task :all do
    fail unless system("rvm #{SUPPORTED_RUBIES.join ','} do bundle exec rake -f #{__FILE__} spec:fast")
  end
end


begin
  require 'yard'
  YARD::Rake::YardocTask.new(:doc) do |yard|
    yard.files   = ['lib/**/*.rb']
  end
rescue Exception # yard is optional, so don't cause rake to fail if it's missing
end
