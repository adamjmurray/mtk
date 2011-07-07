##############################################
# Description of modules for documentation:

# The top level module for this library
module MTK

  # Internal helper classes used to avoid duplicating code in this library.
  module Helper
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

require 'mtk/helper/collection'
require 'mtk/helper/pseudo_constants'

require 'mtk/transform/mappable'
require 'mtk/transform/transposable'
require 'mtk/transform/invertible'
require 'mtk/transform/set_theory_operations'

require 'mtk/pitch_class'
require 'mtk/pitch_class_set'
require 'mtk/pitch'
require 'mtk/pitch_set'

require 'mtk/event'
require 'mtk/note'
require 'mtk/timeline'

require 'mtk/_constants/pitch_classes'
require 'mtk/_constants/pitches'
require 'mtk/_constants/intervals'
require 'mtk/_constants/intensities'
require 'mtk/_constants/durations'

require 'mtk/pattern/enumerator'
require 'mtk/pattern/abstract_pattern'
require 'mtk/pattern/sequence'
require 'mtk/pattern/cycle'
require 'mtk/pattern/choice'
require 'mtk/pattern/function'
require 'mtk/pattern/lines'
require 'mtk/pattern/palindrome'

require 'mtk/sequencer/event_builder'
require 'mtk/sequencer/abstract_sequencer'
require 'mtk/sequencer/step_sequencer'
require 'mtk/sequencer/rhythmic_sequencer'

require 'mtk/_numeric_extensions'


