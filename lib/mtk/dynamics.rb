module MTK

  # Defines constants for dynamics
  # These values are in the range 0.0 - 1.0, so they can be easily scaled (unlike MIDI velocities).

  module Dynamics

    # pianississimo
    PPP = 0.125

    # pianissimo
    PP = 0.25

    # piano
    P = 0.375

    # mezzo-piano
    MP = 0.5

    # mezzo-forte
    MF = 0.625

    # forte
    F = 0.75

    # fortissimo
    FF = 0.875

    # fortississimo
    FFF = 1.0

  end
end
