# Print the notes in a MIDI file

file = ARGV[0]
unless file
  puts "Usage: ruby #$0 midi_file"
  exit 1
end

require 'mtk'
require 'mtk/io/midi_file'
include MTK

puts MIDIFile(file).to_timelines
