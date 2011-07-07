module MTK
  module Sequencer

    # A helper class for {Sequencer}s.
    # Takes a list of patterns and constructs a list of {Events}s from the next elements in each pattern.
    class EventBuilder

      DEFAULT_PITCH = MTK::Pitches::C4
      DEFAULT_INTENSITY = MTK::Intensities::f
      DEFAULT_DURATION = 1

      def initialize(patterns, options={})
        @patterns = patterns
        @default_pitch = options.fetch :default_pitch, DEFAULT_PITCH
        @default_intensity = options.fetch :default_intensity, DEFAULT_INTENSITY
        @default_duration = options.fetch :default_duration, DEFAULT_DURATION
        @max_interval = options.fetch :max_interval, 12
      end

      def next_events
        pitches = []
        intensity = @default_intensity
        duration = @default_duration

        for pattern in @patterns
          element = pattern.next
          case element
            when Pitch         then pitches << element
            when PitchSet      then pitches += element.pitches
            when PitchClass    then pitches += pitches_for_pitch_classes([element], @previous_pitch || @default_pitch)
            when PitchClassSet then pitches += pitches_for_pitch_classes(element, @previous_pitch || @default_pitch)
            else case pattern.type
              # TODO: handle intervals, but should be smarter about handling for sets... (i.e. add interval too everything in set)
              when :intensity then intensity = element
              when :duration then duration = element
            end
          end
        end

        if not pitches.empty?
          @previous_pitch = pitches.last
          pitches.map{|pitch| Note(pitch,intensity,duration) }
        else
          nil
        end
      end

      ########################
      private

      def pitches_for_pitch_classes(pitch_classes, previous_pitch)
        pitches = []
        for pitch_class in pitch_classes
          pitch = previous_pitch.nearest(pitch_class)
          pitch -= 12 if pitch > @default_pitch+@max_interval # keep within max_distance of start (default is one octave)
          pitch += 12 if pitch < @default_pitch-@max_interval
          pitches << pitch
        end
        pitches
      end

    end

  end
end
