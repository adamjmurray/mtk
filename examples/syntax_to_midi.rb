# Generate a MIDI file by reading in a file containing the MTK custom syntax (see mtk_grammar.citrus and grammar_spec.rb)
#
# NOTE: this blindly overwrites any existing MTK-syntax_to_midi.mid file, unless a second argument is provided

require 'mtk'
require 'mtk/io/midi_file'

input = ARGV[0]
if input.nil?
  STDERR.puts "Input file is required."
  STDERR.puts "Usage: #{$0} input [output]"
  exit 1
end

unless File.exists? input
  STDERR.puts "Cannot read file: #{input}"
  exit 2
end

output = ARGV[1] || "MTK-#{File.basename(__FILE__,'.rb')}.mid"


syntax = IO.read(input)
sequencer = MTK::Lang::Parser.parse(syntax)
timeline = sequencer.to_timeline

MTK::MIDIFile(output).write timeline

