module MTK
  module Groups

    # A chord that's not associated with specific {Pitch}es, but is instead represented in terms of an {IntervalGroup}
    # and a scale index.
    #
    class RelativeChord

      # The names of pre-defined relative chords. See {MTK::Lang::RelativeChords} for more info.
      NAMES = %w[I i II ii III iii IV iv V v VI vi VII vii VIII viii IX ix].freeze


      attr_reader :scale_index, :interval_group

      def initialize scale_index, interval_group
        @scale_index = scale_index
        @interval_group = interval_group
      end

      def self.from_s(s)
        s = s.to_s
        case s
          when 'I'    then new(0, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'i'    then new(0, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'II'   then new(1, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'ii'   then new(1, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'III'  then new(2, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'iii'  then new(2, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'IV'   then new(3, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'iv'   then new(3, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'V'    then new(4, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'v'    then new(4, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'VI'   then new(5, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'vi'   then new(5, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'VII'  then new(6, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'vii'  then new(6, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'VIII' then new(7, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'viii' then new(7, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          when 'IX'   then new(8, MTK::Lang::IntervalGroups::MAJOR_TRIAD)
          when 'ix'   then new(8, MTK::Lang::IntervalGroups::MINOR_TRIAD)
          else raise ArgumentError.new("Invalid RelativeChord string '#{s}'")
        end
      end


      def to_chord(scale, octave=4)
        root = scale[@scale_index % scale.length]
        if root.is_a? MTK::Core::PitchClass
          root = MTK::Core::Pitch[root, octave]
        end
        pitches = @interval_group.to_pitches(root)
        MTK::Groups::Chord.new(pitches)
      end


      def ==(other)
        other.is_a? self.class and @scale_index == other.scale_index and @interval_group == other.interval_group
      end
    end

  end
end
