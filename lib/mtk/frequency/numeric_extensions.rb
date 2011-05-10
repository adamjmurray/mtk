class Numeric

  def semitones
    MTK::Frequency::Semitones.new( self )
  end
  
  def cents
    MTK::Frequency::Cents.new( self )
  end

  def hz
    MTK::Frequency::Hertz.new( self )
  end
  alias Hz hz

  def khz
    MTK::Frequency::Kilohertz.new( self )
  end
  alias kHz khz
  
end
