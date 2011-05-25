module MTK
  module Pattern

    # A {Sequence} of {Note}s
    class NoteSequence

      attr_reader :pitch_sequence, :intensity_sequence, :duration_sequence

      attr_accessor :pitch, :intensity, :duration

      def initialize(pitches, intensities=nil, durations=nil, defaults={})
        @pitch_sequence     = PitchSequence.new(pitches)
        @intensity_sequence = Sequence.new(intensities)
        @duration_sequence  = Sequence.new(durations)
        @default = {:pitch => Pitches::C4, :intensity => Dynamics::mf, :duration => 1}.merge defaults
        reset
      end

      def pitches
        @pitch_sequence.elements
      end

      def intensities
        @intensity_sequence.elements
      end

      def durations
        @duration_sequence.elements
      end

      # reset the Sequence to the beginning
      def reset
        @pitch_sequence.reset
        @intensity_sequence.reset
        @duration_sequence.reset

        @pitch = @default[:pitch]
        @intensity = @default[:intensity]
        @duration = @default[:duration]
      end

      # return next {Note} in sequence
      def next
        @pitch = @pitch_sequence.next || @pitch
        @intensity = @intensity_sequence.next || @intensity
        @duration = @duration_sequence.next || @duration


        case @pitch
          when PitchSet,Array then Chord.new(@pitch, @intensity, @duration)
          else Note.new(@pitch, @intensity, @duration)
        end
      end

    end

  end
end


