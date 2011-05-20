require 'mtk/midi/file_reader'

describe MTK::MIDI::FileReader do

  let(:file) { File.join(File.dirname(__FILE__), '..', '..', 'test.mid') }
  let(:reader) { MTK::MIDI::FileReader.new }

  describe "#read" do
    it "should read a MIDI file" do
      timelines = reader.read(file)
      timelines.length.should == 1 # one track
      timelines.first.should == {
        0.0 => [Note.new(C4, 126/127.0, 0.25)],
        1.0 => [Note.new(Db4, 99/127.0, 0.5)],
        2.0 => [Note.new(D4,  72/127.0, 0.75)],
        3.0 => [Note.new(Eb4, 46/127.0, 1.0), Note.new(E4, 46/127.0, 1.0)]
      }
    end
  end

end
