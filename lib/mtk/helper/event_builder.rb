module MTK
  module Helper

    # A helper class for {Sequencer}s.
    # Takes a list of patterns and constructs a list of {Event}s from the next elements in each pattern.
    class EventBuilder

      DEFAULT_PITCH = MTK::Constant::Pitches::C4
      DEFAULT_INTENSITY = MTK::Constant::Intensities::f
      DEFAULT_DURATION = 1

      def initialize(patterns, options={})
        @patterns = patterns
        @options = options
        @max_interval = options.fetch :max_interval, 12
        rewind
      end

      # Build a list of events from the next element in each {Pattern}
      # @return [Array] an array of events
      def next
        pitches = []

        for pattern in @patterns
          element = pattern.next

          case element
            when Pitch           then pitches << element
            when PitchClass      then pitches += pitches_for_pitch_classes([element], @previous_pitch || @default_pitch)
            when PitchClassSet   then pitches += pitches_for_pitch_classes(element, @previous_pitch || @default_pitch)
            when PitchCollection then pitches += element.pitches # this must be after the PitchClassSet case, because that is also a PitchCollection
          else
            case pattern.type
              when :pitch
                if element.is_a? Numeric # then add as an interval
                  if @previous_pitches
                    pitches += @previous_pitches.map{|pitch| pitch + element }
                  else
                    pitches << ((@previous_pitch || @default_pitch) + element)
                  end
                else # other supported types were handled above in the first 'case'
                  pitches << :skip
                end
              when :intensity then intensity = element || :skip
              when :duration then duration = element || :skip
            end
          end
        end

        pitches << @default_pitch if pitches.empty?
        intensity ||= @default_intensity
        duration ||= @default_duration

        return nil if intensity==:skip or duration==:skip or pitches.include? :skip

        @previous_pitch = pitches.last
        @previous_pitches = pitches.length > 1 ? pitches : nil

        pitches.map{|pitch| Note(pitch,intensity,duration) }
      end

      # Reset the EventBuilder to its initial state
      def rewind
        @default_pitch = @options.fetch :default_pitch, DEFAULT_PITCH
        @default_intensity = @options.fetch :default_intensity, DEFAULT_INTENSITY
        @default_duration = @options.fetch :default_duration, DEFAULT_DURATION
        @previous_pitch = nil
        @previous_pitches = nil
        @patterns.each{|pattern| pattern.rewind }
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
