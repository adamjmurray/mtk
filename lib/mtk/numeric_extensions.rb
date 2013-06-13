# Optional Numeric methods for converting to {MTK::Core} objects.
#
# @note you must require 'mtk/numeric_extensions' to use these methods.
#
class Numeric

  # Convert a Numeric to a {MTK::Core::Pitch}
  # @example 60.to_pitch => C4
  def to_pitch
    MTK::Core::Pitch.from_f(self)
  end


  # Convert a Numeric to a {MTK::Core::PitchClass}
  # @example 2.to_pitch_class => D
  def to_pitch_class
    MTK::Core::PitchClass.from_f(self)
  end


  # Convert a Numeric to a {MTK::Core::Duration}
  # @example 3.5.to_duration + 1.beat + 2.beats
  def to_duration
    MTK::Core::Duration.from_f(self)
  end
  alias beats to_duration
  alias beat to_duration


  # Convert a Numeric to a {MTK::Core::Intensity}
  # @note The standard range of intensity values is from 0.0 - 1.0
  # @example 1.to_pitch => fff
  def to_intensity
    MTK::Core::Intensity.from_f(self)
  end

  # Convert a Numeric percentage to a {MTK::Core::Intensity}
  # @note The standard range of intensity percentages is from 0 - 100
  # @example 100.percent_intensity => fff
  def percent_intensity
    MTK::Core::Intensity.from_f(self/100.0)
  end

  # Convert a Numeric to a {MTK::Core::Interval}
  # @example 3.5.to_interval + 1.semitone + 2.semitones
  def to_interval
    MTK::Core::Interval.from_f(self)
  end
  alias semitones to_interval
  alias semitone to_interval

  # Convert a Numeric cents value to a {MTK::Core::Interval}
  # @example 100.cents => 1.semitone
  def cents
    MTK::Core::Interval.from_f(self/100.0)
  end
  alias cent cents

  # Convert a Numeric octaves value to a {MTK::Core::Interval}
  # @example 1.octave => 12.semitones
  def octaves
    MTK::Core::Interval.from_f(self * 12)
  end
  alias octave octaves

end
