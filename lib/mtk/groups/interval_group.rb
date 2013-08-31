module MTK
  module Groups

    # An group of {Interval}s with an optional base {Pitch}, {PitchClass}, or Numeric index.
    #
    # With a base {Pitch} or {PitchClass}, this can be converted to an absolute {PitchGroup} or {PitchClassGroup}.
    #
    # With a base index, another {PitchGroup} or {PitchClassGroup} can be given to establish a base {Pitch} or {PitchClass}.
    # In this case, this object represents an abstract chord or pitch class set, independent of any scale.
    #
    class IntervalGroup < Group

      MAJOR_TRIAD = [ MTK::Core::Interval[0], MTK::Core::Interval[4], MTK::Core::Interval[7] ].freeze
      MINOR_TRIAD = [ MTK::Core::Interval[0], MTK::Core::Interval[3], MTK::Core::Interval[7] ].freeze

      alias intervals elements

      attr_reader :base

      def initialize(intervals,base=nil)
        super(intervals)
        @base = base
      end

      def self.from_s(s)
        s = s.to_s
        case s
          when 'I'    then new(MAJOR_TRIAD, 0)
          when 'i'    then new(MINOR_TRIAD, 0)
          when 'II'   then new(MAJOR_TRIAD, 1)
          when 'ii'   then new(MINOR_TRIAD, 1)
          when 'III'  then new(MAJOR_TRIAD, 2)
          when 'iii'  then new(MINOR_TRIAD, 2)
          when 'IV'   then new(MAJOR_TRIAD, 3)
          when 'iv'   then new(MINOR_TRIAD, 3)
          when 'V'    then new(MAJOR_TRIAD, 4)
          when 'v'    then new(MINOR_TRIAD, 4)
          when 'VI'   then new(MAJOR_TRIAD, 5)
          when 'vi'   then new(MINOR_TRIAD, 5)
          when 'VII'  then new(MAJOR_TRIAD, 6)
          when 'vii'  then new(MINOR_TRIAD, 6)
          when 'VIII' then new(MAJOR_TRIAD, 7)
          when 'viii' then new(MINOR_TRIAD, 7)
          when 'IX'   then new(MAJOR_TRIAD, 8)
          when 'ix'   then new(MINOR_TRIAD, 8)
          else raise ArgumentError.new("Invalid IntervalGroup string '#{s}'")
        end
      end


      def to_pitch_class_group(context={})
        base = context.fetch(:base, @base)
        case base
          when PitchClass
            base_pitch_class = base
          when Pitch
            base_pitch_class = base.pitch_class
          when Numeric
            scale = context[:scale]
            raise ArgumentError.new("A :scale option must be provided for a Numeric base index") unless scale
            base_pitch_class = scale[base % scale.size]
          else
            raise ArgumentError.new("Invalid base: #{base}")
        end

        pitch_classes = @elements.map{|interval| base_pitch_class + interval }
        MTK::Groups::PitchClassGroup.new(pitch_classes)
      end

      def to_pitch_group(context={})
        base = context.fetch(:base, @base)
        case base
          when Pitch
            base_pitch = base
          when Numeric
            scale = context[:scale]
            nearest_pitch = context[:nearest_pitch]
            raise ArgumentError.new("A :scale and nearest_pitch option must be provided for a Numeric base index") unless scale && nearest_pitch
            base_pitch = nearest_pitch.nearest(scale[base % scale.size])
          else
            raise ArgumentError.new("Invalid base: #{base}")
        end

        pitches = @elements.map{|interval| base_pitch + interval }
        MTK::Groups::PitchGroup.new(pitches)
      end

    end
  end
end