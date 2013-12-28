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
        force_rest = false

        @patterns.each do |pattern|
          pattern_value = pattern.next

          elements = if pattern_value.is_a? Enumerable and not pattern_value.is_a? MTK::Groups::Group
            pattern_value # pattern Chains already return an Array of elements
          else
            [pattern_value]
          end

          elements.each do |element|
            return nil if element.nil?

            if element.is_a? MTK::Lang::ModifiedElement
              modifier = element.modifier
              element = element.element
            end

            case element
              when MTK::Core::Pitch
                pitches << element
                @previous_pitch = element

              when MTK::Groups::PitchGroup
                pitches += element.pitches
                @previous_pitch = pitches.last

              when MTK::Core::PitchClass
                pitch = @previous_pitch.nearest(element)
                pitch += pitch_offset_for_modifier(pitch, modifier) if modifier
                pitches << pitch
                @previous_pitch = pitch

              when MTK::Groups::PitchClassGroup
                pitches += element.map{|pitch_class| @previous_pitch.nearest(pitch_class) }
                @previous_pitch = pitches.last

              when MTK::Core::Duration
                duration ||= 0
                duration += element

              when MTK::Core::Intensity
                intensities << element

              when MTK::Groups::IntervalGroup
                chord_pitches = element.to_pitches(@previous_pitch)
                pitches += chord_pitches
                @previous_pitch = chord_pitches.first # use the "chord root" to control nearest pitch behavior for the next evaluation

              when MTK::Groups::RelativeChord
                chord_pitches = element.to_pitches(@scale, @previous_pitch)
                if modifier
                  offset = pitch_offset_for_modifier(chord_pitches.first, modifier)
                  chord_pitches.map!{|pitch| pitch += offset}
                end
                pitches.concat(chord_pitches)
                @previous_pitch = chord_pitches.first # use the "chord root" to control nearest pitch behavior for the next evaluation

              when MTK::Core::Interval
                if @previous_pitches
                  pitches += @previous_pitches.map{|pitch| pitch + element }
                else
                  pitches << (@previous_pitch + element)
                end
                @previous_pitch = pitches.last

              when MTK::Lang::Variable
                case
                  when element.scale?
                    @scale = element.value
                    return self.next

                  when element.scale_element?
                    evaluate_scale(element, pitches)

                  when element.arpeggio?
                    @arpeggio = element.value
                    if @arpeggio.is_a? MTK::Lang::ModifiedElement
                      modifier = @arpeggio.modifier
                      @arpeggio = @arpeggio.element
                    end
                    if @arpeggio.is_a? MTK::Groups::RelativeChord
                      @arpeggio = @arpeggio.to_chord(@scale, @previous_pitch)
                      if modifier
                        @arpeggio = @arpeggio.transpose pitch_offset_for_modifier(@arpeggio.first, modifier)
                      end
                    end
                    return self.next

                  when element.arpeggio_element?
                    evaluate_arpeggio(element, pitches)

                  else
                    # Note: valid ForEach variables will already have been evaluated by the Pattern
                    STDERR.puts "#{self.class}#next: Encountered unsupported / out-of-context variable #{element}"
                end

              when MTK::Lang::Modifier
                case
                  when element.octave?
                    @previous_pitch += 12 * element.value # element.value is the octave delta
                    return self.next

                  when element.force_rest?
                    force_rest = true

                  when element.skip?
                    return self.next

                  else
                    STDERR.puts "#{self.class}#next: Encountered unsupported modifier #{element}"
                end

              else
                STDERR.puts "#{self.class}#next: Unexpected type '#{element.class}'"
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

        @previous_pitches = pitches.length > 1 ? pitches : nil
        @previous_intensity = intensity
        @previous_duration = duration

        if force_rest or duration.rest?
          [MTK::Events::Rest.new(duration,@channel)]
        else
          pitches.uniq.map{|pitch| MTK::Events::Note.new(pitch,duration,intensity,@channel) }
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

        value = element.value
        modifier = nil

        if value.is_a? MTK::Lang::ModifiedElement
          modifier = value.modifier
          value = value.element
        end
        
        case element.name
          when :index
            pitch_class = @scale[value % @scale.size]
            pitch = @previous_pitch.nearest(pitch_class)
            pitch += pitch_offset_for_modifier(pitch, modifier) if modifier
            pitches << pitch
            @previous_pitch = pitches.last
            @previous_scale_index = value

          when :increment
            pitch_class = @scale[(@previous_scale_index + value) % @scale.size]
            pitches << @previous_pitch.nearest(pitch_class)
            @previous_pitch = pitches.last
            @previous_scale_index += value

          when :random
            pitch_class = @scale.random
            pitches << @previous_pitch.nearest(pitch_class)
            @previous_pitch = pitches.last
            @previous_scale_index = @scale.find_index(pitch_class)

          when :all
            previous_pitch = @previous_pitch
            # after @previous_pitch, use each pitch of the scale as the previous_pitch to select the next one
            scale_pitches = @scale.pitch_classes.map{|pitch_class| previous_pitch = previous_pitch.nearest(pitch_class) }
            pitches.concat(scale_pitches)
            @previous_pitch = scale_pitches.first # treat the scale root as the most important pitch

          else
            STDERR.puts "#{self.class}#next: Encountered unsupported scale element #{element}"
            return
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
            pitch = @arpeggio.random
            pitches << pitch
            @previous_arpeggio_index = @arpeggio.find_index(pitch)

          when :all
            pitches.concat(@arpeggio.pitches)

          else
            STDERR.puts "#{self.class}#next: Encountered unsupported arpeggio element #{element}"
        end

        @previous_pitch = pitches.last
      end


      def pitch_offset_for_modifier(pitch, modifier)
        # we've already evaluated the pitch for the pitch class, now let's apply the modifier to the pitch
        offset = 0
        if modifier.octave?
          delta = modifier.value
          if delta > 0
            if pitch < @previous_pitch
              offset += 12 # enforce the "nearest above" behavior
            end
            offset += 12*(delta-1) # apply additional octave offsets
          elsif delta < 0
            if pitch > @previous_pitch
              offset -= 12 # enforce the "nearest below" behavior
            end
            offset += 12*(delta+1) # apply additional octave offsets (remember delta is negative)
          end
        end
        offset
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
