module Kreet
  
  # Constants for pitches in the standard MIDI range.
  
  module Pitches
    
    PITCHES = []
    
    128.times do |note_number|
      pitch = Pitch.from_i( note_number )
      PITCHES << pitch
      octave_str = pitch.octave.to_s.sub(/-/,'_') # '_1' for -1
      const_set "#{pitch.pitch_class}#{octave_str}", pitch
    end
    
  end
  
end