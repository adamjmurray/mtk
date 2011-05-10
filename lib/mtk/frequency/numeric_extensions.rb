class Numeric

  def to_semitones
    MTK::Frequency::Semitones.new( self )
  end
  alias semitones to_semitones
  
  def to_cents
    MTK::Frequency::Cents.new( self )
  end
  alias cents to_cents

  def to_hz
    MTK::Frequency::Hertz.new( self )
  end
  alias hz to_hz
  alias Hz to_hz

  def to_khz
    MTK::Frequency::Kilohertz.new( self )
  end
  alias khz to_khz
  alias kHz to_khz
  
end
