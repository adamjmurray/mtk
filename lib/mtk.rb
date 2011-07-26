# Description of modules for documentation:

# The top level module for this library
module MTK

  # Constants for modeling frequency, intensity, and duration.
  module Constant
  end

  # Internal helper classes used to avoid duplicating code in this library.
  module Helper
  end

  # Musical events, such as {Event::Note}s and {Event::Parameter} changes, that are arranged in time via a {Timeline}.
  module Event
  end

  # Classes that emit elements one at a time. Used by {Sequencer}s to construct {Timeline}s.
  #
  # The core interface for Pattern classes is {Pattern::Enumerator#next} and {Pattern::Enumerator#rewind}.
  module Pattern
  end

  # Classes that assemble {Pattern}s into {Timeline}s.
  module Sequencer
  end

  # Optional classes for the "MTK language", which let's you compose music via MTK without writing any Ruby code
  module Lang
  end

  # Optional classes for MIDI input and output.
  module MIDI
  end

end

require 'mtk/pitch_class'
require 'mtk/pitch'

require 'mtk/helper/collection'
require 'mtk/helper/pseudo_constants'
require 'mtk/helper/convert'

require 'mtk/transform/mappable'
require 'mtk/transform/transposable'
require 'mtk/transform/invertible'
require 'mtk/transform/set_theory_operations'

require 'mtk/pitch_class_set'
require 'mtk/melody'
require 'mtk/chord'

require 'mtk/event/abstract_event'
require 'mtk/event/note'
require 'mtk/event/parameter'

require 'mtk/timeline'

require 'mtk/constant/pitch_classes'
require 'mtk/constant/pitches'
require 'mtk/constant/intervals'
require 'mtk/constant/intensities'
require 'mtk/constant/durations'

require 'mtk/pattern/enumerator'
require 'mtk/pattern/abstract_pattern'
require 'mtk/pattern/sequence'
require 'mtk/pattern/cycle'
require 'mtk/pattern/choice'
require 'mtk/pattern/function'
require 'mtk/pattern/lines'
require 'mtk/pattern/palindrome'

require 'mtk/helper/event_builder'
require 'mtk/sequencer/abstract_sequencer'
require 'mtk/sequencer/step_sequencer'
require 'mtk/sequencer/rhythmic_sequencer'
require 'mtk/sequencer/legato_sequencer'



