class Numeric

  def semitones
    self
  end

  def cents
    self/100.0
  end

  def minor_seconds
    self
  end

  def major_seconds
    self * 2
  end

  def minor_thirds
    self * 3
  end

  def major_thirds
    self * 4
  end

  def perfect_fourths
    self * 5
  end

  def tritones
    self * 6
  end
  alias augmented_fourths tritones
  alias diminshed_fifths tritones

  def perfect_fifths
    self * 7
  end

  def minor_sixths
    self * 8
  end

  def major_sixths
    self * 9
  end

  def minor_sevenths
    self * 10
  end

  def major_sevenths
    self * 11
  end

  def octaves
    self * 12
  end

end
