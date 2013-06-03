require 'mtk'
require 'mtk/lang/grammar'
require 'mtk/helpers/lilypond'
include MTK

def arg_error(error)
  puts "Usage: ruby #$0 syntax output_file"
  puts error
  exit 1
end

syntax = ARGV[0]
arg_error "MTK syntax string not provided" unless syntax


file = ARGV[1]
arg_error "The output_file must end in '.png', '.pdf', or '.ps'" unless file


sequencer = MTK::Lang::Grammar.parse(syntax)
timeline = sequencer.to_timeline
# Helpers::Lilypond.open(file).write(timeline)
Helpers::Lilypond.open(file, dpi:300).write(timeline) # higher resolution PNG
