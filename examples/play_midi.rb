# Play a given MIDI file with the given MIDI output

file, output_name = ARGV[0], ARGV[1]
unless file
  puts "Usage: ruby #$0 midi_file [output_device]"
  exit 1
end

require 'mtk'
require 'mtk/midi/file'
require 'mtk/helpers/output_selector'

output = MTK::Helpers::OutputSelector.ensure_output(output_name)

timeline = MTK.MIDI_File(file).to_timelines

output.play(timeline)
