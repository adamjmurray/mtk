require 'spec_helper'
require 'mtk/midi/file_writer'
require 'tempfile'

module MTK::MIDI
  describe MTK::MIDI::FileWriter do

    before do
      @tempfile = Tempfile.new 'MTK-midi_file_writer_spec'
    end

    after do
      @tempfile.close
      @tempfile.unlink
    end

    let(:timeline) do
      Timeline.new({
        0 => Note.new(C4, 0.7, 1),
        1 => Note.new(G4, 0.8, 1),
        2 => Note.new(C5, 0.9, 1)
      })
    end
    let(:writer) { FileWriter.new(@tempfile) }

    describe "#write" do
      it 'writes the given Timeline to a file' do
        writer.write(timeline)

        # Now let's parse the file and check some expectations
        File.open(@tempfile.path, 'rb') do |file|
          seq = MIDI::Sequence.new
          seq.read(file)
          seq.tracks.size.should == 2 # one meta-track plus the 'notes' track

          track = seq.tracks.last
          event_counts = Hash.new {|hash,event_class| hash[event_class] = 0 }
          note_ons = []
          note_offs = []
          for event in track.events
            event_counts[event.class] += 1
            note_ons << event if event.is_a? MIDI::NoteOnEvent
            note_offs << event if event.is_a? MIDI::NoteOffEvent
          end
          # expect a meta-event to set the track name, an initial program change, three note-ons, and three note-offs
          event_counts[MIDI::MetaEvent].should == 1
          event_counts[MIDI::ProgramChange].should == 1
          event_counts[MIDI::NoteOnEvent].should == 3
          event_counts[MIDI::NoteOffEvent].should == 3

          note_ons[0].note.should == C4.to_i
          note_ons[0].velocity.should be_within(0.5).of(127*0.7)
          note_offs[0].note.should == C4.to_i

          note_ons[1].note.should == G4.to_i
          note_ons[1].velocity.should be_within(0.5).of(127*0.8)
          note_offs[1].note.should == G4.to_i

          note_ons[2].note.should == C5.to_i
          note_ons[2].velocity.should be_within(0.5).of(127*0.9)
          note_offs[2].note.should == C5.to_i

          note_ons[0].time_from_start.should == 0
          note_offs[0].time_from_start.should == 480
          note_ons[1].time_from_start.should == 480
          note_offs[1].time_from_start.should == 960
          note_ons[2].time_from_start.should == 960
          note_offs[2].time_from_start.should == 1440
        end
      end
    end

  end
end
