module MTK
  module Patterns

    # A special pattern that takes a list of event properties and/or patterns and emits lists of {Events::Event}s
    class Chain < Pattern

      DEFAULT_PITCH = MTK::Constants::Pitches::C4
      DEFAULT_INTENSITY = MTK::Constants::Intensities::o
      DEFAULT_DURATION = 1

      def initialize(patterns, options={})
        @patterns = patterns
        @options = options
        @max_interval = options.fetch :max_interval, 127
        rewind
      end

      # Build a list of events from the next element in each {Patterns::Pattern}
      # @return [Array] an array of events
      def next
        pitches = []
        intensity = nil
        duration = nil

        @patterns.each do |pattern|
          if pattern.is_a? MTK::Patterns::Pattern
            element = pattern.next
          else
            element = pattern
          end

          return nil if element.nil? or element == :skip

          case element
            when Pitch           then pitches << element
            when PitchClass      then pitches += pitches_for_pitch_classes([element], @previous_pitch || @default_pitch)
            when PitchClassSet   then pitches += pitches_for_pitch_classes(element, @previous_pitch || @default_pitch)
            when Helpers::PitchCollection then pitches += element.pitches # this must be after the PitchClassSet case, because that is also a PitchCollection
            when Duration then duration = element
            when Intensity then intensity = element
            when Interval then
              if @previous_pitches
                pitches += @previous_pitches.map{|pitch| pitch + element }
              else
                pitches << ((@previous_pitch || @default_pitch) + element)
              end
            # TODO? String/Symbols for special behaviors like :skip, or :break (something like StopIteration for the current Pattern?)
            # else ??? raise error?
          end
        end

        # TODO: use previous values here instead?
        pitches << @default_pitch if pitches.empty?
        intensity ||= @default_intensity
        duration ||= @default_duration

        return nil if intensity==:skip or duration==:skip or pitches.include? :skip

        @previous_pitch = pitches.last
        @previous_pitches = pitches.length > 1 ? pitches : nil

        pitches.map{|pitch| Note(pitch,intensity,duration) }
      end

      # Reset the EventChain to its initial state
      def rewind
        @default_pitch = @options.fetch :default_pitch, DEFAULT_PITCH
        @default_intensity = @options.fetch :default_intensity, DEFAULT_INTENSITY
        @default_duration = @options.fetch :default_duration, DEFAULT_DURATION
        @previous_pitch = nil
        @previous_pitches = nil
        @patterns.each{|pattern| pattern.rewind if pattern.is_a? MTK::Patterns::Pattern }
      end

      ########################
      private

      def pitches_for_pitch_classes(pitch_classes, previous_pitch)
        pitches = []
        pitch_classes.each do |pitch_class|
          pitch = previous_pitch.nearest(pitch_class)
          pitch -= 12 if pitch > @default_pitch+@max_interval or pitch > 127 # keep within max_distance of start (default is one octave)
          pitch += 12 if pitch < @default_pitch-@max_interval or pitch < 0
          pitches << pitch
        end
        pitches
      end

    end

  end
end
