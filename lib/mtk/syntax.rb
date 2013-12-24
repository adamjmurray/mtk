# Includes constants defined in the {MTK::Lang} module
# and Ruby methods to correspond to the custom syntax defined in mtk_grammar.citrus
#
# This module is for convenience when working with Ruby, and doesn't do much unless you include it.
#
module MTK::Syntax
  extend MTK::Lang::PseudoConstants

  include MTK::Lang::PitchClasses
  include MTK::Lang::Pitches
  include MTK::Lang::Durations
  include MTK::Lang::Intensities
  include MTK::Lang::Intervals
  include MTK::Lang::IntervalGroups
  include MTK::Lang::RelativeChords

  include MTK::Core
  include MTK::Groups
  include MTK::Events
  include MTK::Patterns   # includes helper constructors like Sequence(*args)
  include MTK::Sequencers # includes helper constructors like LegatoSequencer(*args)

  define_constant :d, MTK::Core::Duration::DOTTED
  define_constant :t, MTK::Core::Duration::TRIPLET


  # TODO? should the following methods move into the Variable module? Maybe this module should be as minimal as possible?

  # Define a scale variable for use inside {MTK::Patterns}
  def scale_def(*args)
    if args.first.is_a? MTK::Core::PitchClass
      root_pitch_class = args[0]
      scale_name = args[1]
      scale_intervals = MTK::Lang::IntervalGroups.find_scale(scale_name)
      raise "Invalid scale name #{scale_name}" unless scale_intervals
      name = "#{root_pitch_class} #{scale_name}"
      pitch_class_group = MTK.PitchClassGroup(scale_intervals.to_pitch_classes(root_pitch_class)) if scale_intervals
    else
      name = args.inspect
      pitch_class_group = MTK.PitchClassGroup(args)
    end
    MTK::Lang::Variable.new(MTK::Lang::Variable::SCALE, name, pitch_class_group)
  end

  # Define a variable that looks up a pitch class within the most recently defined scale
  def scale(arg)
    name,value = case arg
      when Fixnum  then [:index, arg]
      when /^\++$/ then [:increment, arg.size]
      when /^-+$/  then [:increment, -arg.size]
      when '?'     then [:random, nil]
      when '!'     then [:all, nil]
      else raise "Invalid scale variable #{arg}"
    end
    MTK::Lang::Variable.new(MTK::Lang::Variable::SCALE_ELEMENT, name, value)
  end

  # Define an arpeggio variable for use inside {MTK::Patterns}
  def arp_def(*args)
    # TODO: support pitch classes
    # TODO: support relative chords
    MTK::Lang::Variable.new(MTK::Lang::Variable::ARPEGGIO, args.inspect, MTK.PitchGroup(args))
  end

  # Define a variable that looks up a pitch within the most recently defined scale
  def arp(arg)
    name,value = case arg
      when Fixnum       then [:index, arg]
      when /^%(-?\d+)$/ then [:modulo_index, $1.to_i]
      when /^\++$/      then [:increment, arg.size]
      when /^-+$/       then [:increment, -arg.size]
      when /^%(\++)$/   then [:modulo_increment, $1.size]
      when /^%(-+)$/    then [:modulo_increment, -$1.size]
      when '?'          then [:random, nil]
      when '!'          then [:all, nil]
      else raise "Invalid arpeggio variable #{arg}"
    end
    MTK::Lang::Variable.new(MTK::Lang::Variable::ARPEGGIO_ELEMENT, name, value)
  end

  def for_each(arg)
    name,value = case arg
      when FixNum then [:index, arg]
      when '?'    then [:random, nil]
      when '!'    then [:all, nil]
      else raise "Invalid 'for each' variable #{arg}"
    end
    MTK::Lang::Variable.new(MTK::Lang::Variable::FOR_EACH_ELEMENT, name, value)
  end


  # TODO? should the following methods move into the Modifier module? Maybe this module should be as minimal as possible?

  def rest
    MTK::Lang::Modifier.new(:force_rest)
  end

end
