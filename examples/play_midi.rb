# Play a given MIDI file with the given MIDI output

file, output_name = ARGV[0], ARGV[1]
unless file
  puts "Usage: ruby #$0 midi_file [output_device]"
  exit 1
end

require 'mtk'
require 'mtk/midi/file'
require 'mtk/helper/output_selector'
include MTK

output = Helper::OutputSelector.ensure_output output_name

# for now this example just plays the first track (MTK's outputs need to be enhanced to support multiple timelines)
timeline = MIDI_File(file).to_timelines.first

output.play timeline
