module MTK
  module Sequencers

    # A special pattern that takes a list of event properties and/or patterns and emits lists of {Events::Event}s
    class EventBuilder

      DEFAULT_PITCH     = MTK.Pitch(60)
      DEFAULT_DURATION  = MTK.Duration(1)
      DEFAULT_INTENSITY = MTK.Intensity(0.75)

      def initialize(patterns, options={})
        @patterns = patterns
        @options = options
        @default_pitch     = if options.has_key? :default_pitch     then MTK.Pitch(    options[:default_pitch])     else DEFAULT_PITCH     end
        @default_duration  = if options.has_key? :default_duration  then MTK.Duration( options[:default_duration])  else DEFAULT_DURATION  end
        @default_intensity = if options.has_key? :default_intensity then MTK.Intensity(options[:default_intensity]) else DEFAULT_INTENSITY end
        @channel = options[:channel]
        @max_interval = options.fetch(:max_interval, 127)
        rewind
      end

      # Build a list of events from the next element in each {Patterns::Pattern}
      # @return [Array] an array of events
      def next
        pitches = []
        intensities = []
        duration = nil

        @patterns.each do |pattern|
          pattern_value = pattern.next

          elements = if pattern_value.is_a? Enumerable and not pattern_value.is_a? MTK::Groups::Group then
            pattern_value # pattern Chains already return an Array of elements
          else
            [pattern_value]
          end

          elements.each do |element|
            return nil if element.nil? or element == :skip

            case element
              when MTK::Core::Pitch
                pitches << element
                @previous_pitch = element

              when MTK::Groups::PitchGroup
                pitches += element.pitches
                @previous_pitch = pitches.last

              when MTK::Core::PitchClass
                pitch = @previous_pitch.nearest(element)
                pitches << pitch
                @previous_pitch = pitch

              when MTK::Groups::PitchClassGroup
                pitches += element.to_a.map{|pitch_class| @previous_pitch.nearest(pitch_class) }
                @previous_pitch = pitches.last

              when MTK::Core::Duration
                duration ||= 0
                duration += element

              when MTK::Core::Intensity
                intensities << element

              when MTK::Core::Interval
                if @previous_pitches
                  pitches += @previous_pitches.map{|pitch| pitch + element }
                else
                  pitches << (@previous_pitch + element)
                end
                @previous_pitch = pitches.last

              when MTK::Lang::Variable
                case
                  when element.arpeggio?
                    # TODO: support things besides PitchGroups and interpret them here
                    # Ideas
                    #   * a PitchClassGroup can be converted to PitchGroup where the first PitchClass is the nearest to @previous_pitch
                    #   * Support a Pitch (or PitchClass) followed by a list of Intervals or integers representing intervals
                    @arpeggio = element.value
                    return self.next
                  when element.arpeggio_element?
                    pitches << @arpeggio.arpeggiate(element.value)
                    @previous_pitch = pitches.last
                  else
                    # ForEach "implicit" variables should already have been evaluated by the Pattern
                    STDERR.puts "#{self.class}#next: Encountered unsupported variable #{element}"
                    # TODO: Add general variable support later
                end

              # TODO? String/Symbols for special behaviors like :skip, or :break (something like StopIteration for the current Pattern?)

              else STDERR.puts "#{self.class}#next: Unexpected type '#{element.class}'"
            end

          end
        end

        pitches   << @previous_pitch if pitches.empty?
        duration ||= @previous_duration.abs

        if intensities.empty?
          intensity = @previous_intensity
        else
          intensity = MTK::Core::Intensity[intensities.map{|i| i.to_f }.inject(:+)/intensities.length] # average the intensities
        end

        # Not using this yet, maybe later...
        # return nil if duration==:skip or intensities.include? :skip or pitches.include? :skip

        constrain_pitch(pitches)

        # @previous_pitch = pitches.last   # Consider doing something different, maybe averaging?
        @previous_pitches = pitches.length > 1 ? pitches : nil
        @previous_intensity = intensity
        @previous_duration = duration

        if duration.rest?
          [MTK::Events::Rest.new(duration,@channel)]
        else
          pitches.map{|pitch| MTK::Events::Note.new(pitch,duration,intensity,@channel) }
        end
      end

      # Reset the EventBuilder to its initial state
      def rewind
        @previous_pitch     = @default_pitch
        @previous_pitches   = [@default_pitch]
        @previous_intensity = @default_intensity
        @previous_duration  = @default_duration
        @arpeggio = MTK.PitchGroup( # Defult arpeggio is chromatic scale starting from middle C
          MTK::Lang::Pitches::C4,
          MTK::Lang::Pitches::Db4,
          MTK::Lang::Pitches::D4,
          MTK::Lang::Pitches::Eb4,
          MTK::Lang::Pitches::E4,
          MTK::Lang::Pitches::F4,
          MTK::Lang::Pitches::Gb4,
          MTK::Lang::Pitches::G4,
          MTK::Lang::Pitches::A4,
          MTK::Lang::Pitches::Ab4,
          MTK::Lang::Pitches::Bb4,
          MTK::Lang::Pitches::B4,
        )
        @max_pitch = nil
        @min_pitch = nil
        @patterns.each{|pattern| pattern.rewind if pattern.is_a? MTK::Patterns::Pattern }
      end

      ########################
      private

      def constrain_pitch(pitches)
        if @max_pitch.nil? or @min_pitch.nil?
          first_pitch = pitches.first

          @max_pitch = first_pitch + @max_interval
          @max_pitch = 127 if @max_pitch > 127

          @min_pitch = first_pitch - @max_interval
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
