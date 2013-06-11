require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb'
begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end
inst = Gem::DependencyInstaller.new
begin
  if RUBY_PLATFORM == 'java'
    puts "Installing jsound gem for MIDI I/O on JRuby"
    inst.install 'jsound', '~> 0.1'
  else
    puts "Installing unimidi gem for MIDI I/O"
    inst.install 'unimidi', '>= 0.3'
  end
rescue
  STERR.puts $!
  exit(1)
end

# This is a hack, see http://www.programmersparadox.com/2012/05/21/gemspec-loading-dependent-gems-based-on-the-users-system/
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
f.write("task :default\n")
f.close