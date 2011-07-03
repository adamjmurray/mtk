# Play a given MIDI file with the given MIDI output
#
# NOTE: this example only runs under JRuby with the jsound and gamelan gems installed

file, output = ARGV[0], ARGV[1]
unless file and output
  puts "Usage: ruby #$0 midi_file output_device"
  exit 1
end

require 'mtk'
require 'mtk/midi/file'
require 'mtk/midi/jsound_output'
include MTK

timeline = MIDI_File(file).to_timelines.first # for now this example just plays the first track (JSoundOutput needs to be enhanced to support multiple timelines)
player = MTK::MIDI::JSoundOutput.new output

player.play timeline
