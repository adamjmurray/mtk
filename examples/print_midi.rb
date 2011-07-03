# Print the notes in a MIDI file

file = ARGV[0]
unless file
  puts "Usage: ruby #$0 midi_file"
  exit 1
end

require 'mtk'
require 'mtk/midi/file'
include MTK

puts MIDI_File(file).to_timelines
