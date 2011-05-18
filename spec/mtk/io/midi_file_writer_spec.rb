require 'spec_helper'
require 'mtk/midi/file_writer'

module MTK::MIDI
  describe MTK::MIDI::FileWriter do

    before do
      #@tempfile = Timefile.new('MTK::MIDI::FileWriter spec')
      @tempfile = '/Users/adam/tmp/test.mid'
    end

    after do
#    @tempfile.close
      #@tempfile.unlink
    end

    let(:timeline) do
      Timeline.new({
        0 => Note.new(C4,0.7,2),
        1 => Note.new(G4,0.8,2),
        2 => Note.new(C5,0.9,2)
      })
    end
    let(:writer) { FileWriter.new(@tempfile) }

    describe "#write" do
      it 'writes the given Timeline to a file' do
        writer.write(timeline)

      end
    end

  end
end
