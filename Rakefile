require 'rspec/core/rake_task'
require 'rake/clean'
require 'erb'

GEM_VERSION = '0.4'

SUPPORTED_RUBIES = %w[ 1.9.3  2.0  jruby-1.7.4 ]

CLEAN.include('html', 'doc', 'coverage', '*.gemspec', '*.gem') # clean and clobber do the same thing for now

task :default => :test


desc "Run RSpec tests with full output"
RSpec::Core::RakeTask.new('test') do |spec|
  spec.rspec_opts = ["--color", "--format", "nested"]
  if ARGV[1]
    # only run specs with filenames starting with the command line argument
    spec.pattern = "spec/**/#{ARGV[1]}*"
  end
end
task :spec => :test  # alias test task as spec task

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
      spec.rspec_opts = ["--color", "--format", "nested", "-r", "#{File.dirname __FILE__}/spec/spec_coverage.rb"]
    end
  end

  desc "Profile RSpec tests and report 10 slowest"
  RSpec::Core::RakeTask.new(:prof) do |spec|
    spec.rspec_opts = ["--color", "-p"]
  end

  desc "Run RSpec tests on all supported versions of Ruby: #{SUPPORTED_RUBIES.join ', '}"
  task :all do
    fail unless system("rvm #{SUPPORTED_RUBIES.join ','} do bundle exec rake -f #{__FILE__} test:fast")
  end
end


begin
  require 'yard'
  YARD::Rake::YardocTask.new(:doc) do |yard|
    yard.files   = ['lib/**/*.rb']
  end
rescue Exception # yard is optional, so don't cause rake to fail if it's missing
end


namespace :gem do
  desc "Install gems for supported versions of Ruby: #{SUPPORTED_RUBIES.join ', '}"
  task :install_dependencies do
    fail unless system("rvm #{SUPPORTED_RUBIES.join ','} do bundle install")
  end

  desc "Build the CRuby and JRuby gems for distribution"
  task :build do
    gem_version = GEM_VERSION

    gem_name = 'mtk'
    platform_specific_depedencies = {unimidi:'~> 0.3'}
    additional_gem_specifications = {}
    generate_gemspec(binding)

    gem_name = 'jmtk'
    platform_specific_depedencies = {jsound:'~> 0.1'}
    additional_gem_specifications = {platform:'java'}
    generate_gemspec(binding)
  end

  def generate_gemspec(erb_bindings)
    gem_name = erb_bindings.eval('gem_name')

    erb = ERB.new(IO.read 'mtk.gemspec.erb')
    gemspec = erb.result(erb_bindings)

    gemspec_filename = "#{gem_name}.gemspec"
    puts "Generating #{gemspec_filename}"
    IO.write(gemspec_filename, gemspec)

    if gem_name == 'jmtk'
      `cp bin/mtk bin/jmtk` # jmtk gem uses this as the binary
    end
    puts "Building gem"
    puts `gem build #{gemspec_filename}`
  ensure
    `rm bin/jmtk`
  end
end
