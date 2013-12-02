module MTK
  module Groups

    # A group of {Interval}s with an optional base {Pitch}, {PitchClass}, or Numeric index.
    #
    # With a base {Pitch} or {PitchClass}, this can be converted to an absolute {PitchGroup} or {PitchClassGroup}.
    #
    # With a base index, another {PitchGroup} or {PitchClassGroup} can be given to establish a base {Pitch} or {PitchClass}.
    # In this case, this object represents an abstract chord or pitch class set, independent of any scale.
    #
    class IntervalGroup < Group

      alias intervals elements

      def initialize(intervals)
        super
      end

      def to_pitch_classes(root)
        root_pitch_class = MTK.PitchClass(root)
        @elements.map{|interval| root_pitch_class + interval }
      end

      def to_pitches(root)
        root_pitch = MTK.Pitch(root)
        @elements.map{|interval| root_pitch + interval }
      end

    end
  end


  # Construct a {MTK::Groups::IntervalGroup} from any compatible argument.
  # @see #MTK::Groups::Chord
  def IntervalGroup(*anything)
    MTK::Groups::IntervalGroup.new MTK::Groups.to_intervals(*anything)
  end
  module_function :IntervalGroup

end