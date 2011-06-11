module MTK
  module Pattern

    # A {Sequence} of pitches
    class PitchSequence < Sequence
      include Transform::Invertible
      include Transform::Transposable

      alias pitches elements

      def self.from_pitch_classes(pitch_classes, start=Pitches::C4, max_distance=12)
        pitch = start
        pitches = []
        for pitch_class in pitch_classes
          pitch = pitch.nearest(pitch_class)
          pitch -= 12 if pitch > start+max_distance # keep within max_distance of start (default is one octave)
          pitch += 12 if pitch < start-max_distance
          pitches << pitch
        end
        new pitches
      end
    end

    def PitchSequence(*anything)
      anything = anything.map{|elem| Pitch(elem)}
      PitchSequence.new(anything)
    end
    module_function :PitchSequence

  end
end
