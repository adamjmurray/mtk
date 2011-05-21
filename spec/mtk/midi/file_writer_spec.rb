require 'spec_helper'
require 'mtk/midi/file_writer'
require 'tempfile'

describe MTK::MIDI::FileWriter do

  before do
    @tempfile = Tempfile.new 'MTK-midi_file_writer_spec'
  end

  after do
    @tempfile.close
    @tempfile.unlink
  end

  let(:writer) { MTK::MIDI::FileWriter.new(@tempfile) }

  describe "#write" do

    it 'writes Notes in a Timeline to a MIDI file' do
      writer.write(
        Timeline.from_hash({
          0 => Note.new(C4, 0.7, 1),
          1 => Note.new(G4, 0.8, 1),
          2 => Note.new(C5, 0.9, 1)
        })
      )

      # Now let's parse the file and check some expectations
      File.open(@tempfile.path, 'rb') do |file|
        seq = MIDI::Sequence.new
        seq.read(file)
        seq.tracks.size.should == 1

        track = seq.tracks.last
        note_ons = []
        note_offs = []
        for event in track.events
          note_ons << event if event.is_a? MIDI::NoteOn
          note_offs << event if event.is_a? MIDI::NoteOff
        end
        note_ons.length.should == 3
        note_offs.length.should == 3

        note_ons[0].note.should == C4.to_i
        note_ons[0].velocity.should be_within(0.5).of(127*0.7)
        note_offs[0].note.should == C4.to_i
        note_ons[0].time_from_start.should == 0
        note_offs[0].time_from_start.should == 480

        note_ons[1].note.should == G4.to_i
        note_ons[1].velocity.should be_within(0.5).of(127*0.8)
        note_offs[1].note.should == G4.to_i
        note_ons[1].time_from_start.should == 480
        note_offs[1].time_from_start.should == 960

        note_ons[2].note.should == C5.to_i
        note_ons[2].velocity.should be_within(0.5).of(127*0.9)
        note_offs[2].note.should == C5.to_i
        note_ons[2].time_from_start.should == 960
        note_offs[2].time_from_start.should == 1440
      end
    end

    it 'writes Chords in a Timeline to a MIDI file' do
      writer.write(
        Timeline.from_hash({
          0 => Chord.new([C4,E4], 0.5, 1),
          2 => Chord.new([G4,B4,D5], 1, 2)
        })
      )

      # Now let's parse the file and check some expectations
      File.open(@tempfile.path, 'rb') do |file|
        seq = MIDI::Sequence.new
        seq.read(file)
        seq.tracks.size.should == 1

        track = seq.tracks.last
        note_ons = []
        note_offs = []
        for event in track.events
          note_ons << event if event.is_a? MIDI::NoteOn
          note_offs << event if event.is_a? MIDI::NoteOff
        end
        note_ons.length.should == 5
        note_offs.length.should == 5

        note_ons[0].note.should == C4.to_i
        note_offs[0].note.should == C4.to_i
        note_ons[0].velocity.should == 64
        note_ons[0].time_from_start.should == 0
        note_offs[0].time_from_start.should == 480

        note_ons[1].note.should == E4.to_i
        note_offs[1].note.should == E4.to_i
        note_ons[1].velocity.should == 64
        note_ons[1].time_from_start.should == 0
        note_offs[1].time_from_start.should == 480

        note_ons[2].note.should == G4.to_i
        note_offs[2].note.should == G4.to_i
        note_ons[2].velocity.should == 127
        note_ons[2].time_from_start.should == 960
        note_offs[2].time_from_start.should == 1920

        note_ons[3].note.should == B4.to_i
        note_offs[3].note.should == B4.to_i
        note_ons[3].velocity.should == 127
        note_ons[3].time_from_start.should == 960
        note_offs[3].time_from_start.should == 1920

        note_ons[4].note.should == D5.to_i
        note_offs[4].note.should == D5.to_i
        note_ons[4].velocity.should == 127
        note_ons[4].time_from_start.should == 960
        note_offs[4].time_from_start.should == 1920
      end
    end

  end

end
