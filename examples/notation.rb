# NOTE: experimental example!
# This requires Lilypond to be installed, see http://lilypond.org/
# The lilypond command must be on your PATH or specificed via the LILYPOND_PATH environment variable.

require 'mtk'
require 'mtk/io/notation'
include MTK

def arg_error(error)
  puts "Usage: ruby #$0 syntax output_file"
  puts error
  exit 1
end

syntax = ARGV[0]
arg_error "MTK syntax string not provided" unless syntax


file = ARGV[1]
arg_error "The output_file must end in '.png', '.pdf', or '.ps'" unless file =~ /\.(png|pdf|ps)$/


sequencer = MTK::Lang::Parser.parse(syntax)
timeline = sequencer.to_timeline
# MTK::IO::Notation.open(file).write(timeline)
MTK::IO::Notation.open(file, dpi:300).write(timeline) # higher resolution PNG
