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

              when MTK::Groups::IntervalGroup
                # TODO? Should this actually be converting to a Chord instead of a PitchGroup?
                # How will this work with chord inversions when that functionality is added later?
                chord = element.to_pitch_group(scale: @scale, nearest_pitch: @previous_pitch).pitches.uniq
                pitches += chord
                @previous_pitch = chord.first # use the chord root to control nearest pitch behavior for the next evaluation

              when MTK::Core::Interval
                if @previous_pitches
                  pitches += @previous_pitches.map{|pitch| pitch + element }
                else
                  pitches << (@previous_pitch + element)
                end
                @previous_pitch = pitches.last

              when MTK::Lang::Variable
                case
                  when element.scale? then @scale = element.value; return self.next

                  when element.scale_element? then evaluate_scale(element, pitches)

                  when element.arpeggio? then @arpeggio = element.value; return self.next

                  when element.arpeggio_element? then evaluate_arpeggio(element, pitches)

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

        @scale = MTK.PitchClassGroup( # default scale is C major
            MTK::Lang::PitchClasses::C,
            MTK::Lang::PitchClasses::D,
            MTK::Lang::PitchClasses::E,
            MTK::Lang::PitchClasses::F,
            MTK::Lang::PitchClasses::G,
            MTK::Lang::PitchClasses::A,
            MTK::Lang::PitchClasses::B,
        )
        @previous_scale_index = 0

        @arpeggio = MTK.PitchGroup( # Default arpeggio is C major triad starting from middle C
          MTK::Lang::Pitches::C4,
          MTK::Lang::Pitches::E4,
          MTK::Lang::Pitches::G4,
        )
        @previous_arpeggio_index = 0

        @max_pitch = nil
        @min_pitch = nil
        @patterns.each{|pattern| pattern.rewind if pattern.is_a? MTK::Patterns::Pattern }
      end


      ################################################
      private

      def evaluate_scale(element, pitches)
        return nil if @scale.empty?

        case element.name
          when :index
            pitch_class = @scale[element.value % @scale.size]
            @previous_scale_index = element.value

          when :increment
            pitch_class = @scale[(@previous_scale_index + element.value) % @scale.size]
            @previous_scale_index += element.value

          when :random
            pitch_class = @scale.random

          else
            STDERR.puts "#{self.class}#next: Encountered unsupported scale element #{element}"
        end

        if pitch_class
          pitches << @previous_pitch.nearest(pitch_class)
          @previous_pitch = pitches.last
        end

      end

      def evaluate_arpeggio(element, pitches)
        case element.name
          when :index, :modulo_index
            wraparound = (element.name == :modulo_index)
            pitches << @arpeggio.arpeggiate(element.value, wraparound)
            @previous_arpeggio_index = element.value

          when :increment, :modulo_increment
            wraparound = (element.name == :modulo_increment)
            pitches << @arpeggio.arpeggiate(@previous_arpeggio_index + element.value, wraparound)
            @previous_arpeggio_index += element.value

          when :random
            pitches << @arpeggio.random

          when :all
            pitches.concat(@arpeggio.pitches)

          else
            STDERR.puts "#{self.class}#next: Encountered unsupported arpeggio element #{element}"
        end

        @previous_pitch = pitches.last
      end


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
