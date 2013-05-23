module MTK
  module Sequencers

    # A special pattern that takes a list of event properties and/or patterns and emits lists of {Events::Event}s
    class EventBuilder

      DEFAULT_PITCH = ::MTK::Constants::Pitches::C4
      DEFAULT_DURATION = ::MTK::Constants::Durations::q
      DEFAULT_INTENSITY = ::MTK::Constants::Intensities::o

      def initialize(patterns, options={})
        @patterns = patterns
        @options = options
        @default_pitch = options.fetch(:default_pitch, DEFAULT_PITCH)
        @default_duration = options.fetch(:default_duration, DEFAULT_DURATION)
        @default_intensity = options.fetch(:default_intensity, DEFAULT_INTENSITY)
        @max_interval = options.fetch(:max_interval, 127)
        rewind
      end

      # Build a list of events from the next element in each {Patterns::Pattern}
      # @return [Array] an array of events
      def next
        pitches = []
        intensity = nil
        duration = nil

        @patterns.each do |pattern|
          pattern_value = pattern.next

          elements = pattern_value.is_a?(Enumerable) ? pattern_value : [pattern_value]
          elements.each do |element|
            return nil if element.nil? or element == :skip

            case element
              when ::MTK::Pitch           then pitches << element
              when ::MTK::PitchClass      then pitches += pitches_for_pitch_classes([element], @previous_pitch || @default_pitch)
              when ::MTK::PitchClassSet   then pitches += pitches_for_pitch_classes(element, @previous_pitch || @default_pitch)
              when ::MTK::Helpers::PitchCollection then pitches += element.pitches # this must be after the PitchClassSet case, because that is also a PitchCollection
              when ::MTK::Duration then duration = element # TODO: if we receive more than one duration (from a Chain) then add them
              when ::MTK::Intensity then intensity = element # TODO: if we receive more than one intensity (from a Chain) then average them
              when ::MTK::Interval then
                if @previous_pitches
                  pitches += @previous_pitches.map{|pitch| pitch + element }
                else
                  pitches << ((@previous_pitch || @default_pitch) + element)
                end
              # TODO? String/Symbols for special behaviors like :skip, or :break (something like StopIteration for the current Pattern?)
              # else ??? raise error?
            end

          end
        end

        # TODO: use previous values here instead? That can be a default. Make the old behavior an option.
        pitches << @default_pitch if pitches.empty?
        intensity ||= @default_intensity
        duration ||= @default_duration

        return nil if intensity==:skip or duration==:skip or pitches.include? :skip

        constrain_pitch(pitches)

        @previous_pitch = pitches.last   # Consider doing something different, maybe averaging?
        @previous_pitches = pitches.length > 1 ? pitches : nil

        pitches.map{|pitch| ::MTK.Note(pitch,intensity,duration) }
      end

      # Reset the EventChain to its initial state
      def rewind
        @previous_pitch = nil
        @previous_pitches = nil
        @max_pitch = nil
        @min_pitch = nil
        @patterns.each{|pattern| pattern.rewind if pattern.is_a? MTK::Patterns::Pattern }
      end

      ########################
      private

      def pitches_for_pitch_classes(pitch_classes, previous_pitch)
        pitch_classes.map{|pitch_class| previous_pitch.nearest(pitch_class) }
      end

      def constrain_pitch(pitches)
        if @max_pitch.nil? or @min_pitch.nil?
          first = pitches.first

          @max_pitch = first + @max_interval
          @max_pitch = 127 if @max_pitch > 127

          @min_pitch = first - @max_interval
          @min_pitch = 0 if @min_pitch < 0

          @small_max_span = (@max_pitch - @min_pitch < 12)
        end

        pitches.map! do |pitch|
          if @small_max_span
            pitch = @max_pitch if pitch > @max_pitch
            pitch = @min_pitch if pitch < @max_pitch
          else
            pitch -= 12 while pitch > @max_pitch
            pitch += 12 while pitch < @min_pitch
          end
          pitch
        end
      end

    end

  end
end
