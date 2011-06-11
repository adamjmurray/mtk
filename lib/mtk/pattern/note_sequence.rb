module MTK
  module Pattern

    # A {Sequence} of {Note}s
    class NoteSequence < Sequence
      include Transform::Invertible
      include Transform::Transposable

      alias notes elements

      def self.from_pitches(pitches, intensity_for=lambda{|p,i,t| Dynamics.mf }, duration_for=lambda{|p,i,t| 1 })
        notes = []
        total = pitches.size
        pitches.each_with_index do |pitch, index|
          notes << Note.new(pitch, intensity_for[pitch,index,total], duration_for[pitch,index,total])
        end
        new notes
      end
    end

  end
end
