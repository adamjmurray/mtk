# Play a given MIDI file with the given MIDI output
#
# REQUIREMENTS:
#   Ruby 1.8+ with the unimidi and gamelan gems installed
# ~or~
#   JRuby 1.5+ with the jsound and gamelan gems installed


file, output_name = ARGV[0], ARGV[1]
unless file and output_name
  puts "Usage: ruby #$0 midi_file output_device"
  exit 1
end

require 'mtk'
require 'mtk/midi/file'
include MTK

if RUBY_PLATFORM == 'java'
  require 'mtk/midi/jsound_output'
  output = MTK::MIDI::JSoundOutput.new output_name
else
  require 'mtk/midi/unimidi_output'
  output = MTK::MIDI::UniMIDIOutput.new output_name
end

timeline = MIDI_File(file).to_timelines.first # for now this example just plays the first track (MTK's outputs need to be enhanced to support multiple timelines)

output.play timeline
