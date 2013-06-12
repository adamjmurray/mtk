# Play a given MIDI file with the given MIDI output

file, output_name = ARGV[0], ARGV[1]
unless file
  puts "Usage: ruby #$0 midi_file [output_device]"
  exit 1
end

require 'mtk'
require 'mtk/io/midi_file'
require_relative 'helpers/output_selector'

output = OutputSelector.ensure_output(output_name)

timeline = MTK.MIDIFile(file).to_timelines

output.play(timeline)
