##############################################
# Description of modules for documentation:

# The top level module for this library
module MTK

  # Classes that emit elements one at a time. Used by {Sequencer}s to construct {Timeline}s.
  #
  # The core interface for Pattern classes is {Pattern::Enumerator#next} and {Pattern::Enumerator#rewind}.
  module Pattern
  end

  # Classes that assemble {Pattern}s into {Timeline}s.
  module Sequencer
  end

  # Optional classes for MIDI input and output.
  module MIDI
  end

end

require 'mtk/collection'
require 'mtk/transforms'

require 'mtk/pitch_class'
require 'mtk/pitch_class_set'
require 'mtk/pitch'
require 'mtk/pitch_set'

require 'mtk/event'
require 'mtk/note'
require 'mtk/timeline'

require 'mtk/pattern/enumerator'
require 'mtk/pattern/abstract_pattern'
require 'mtk/pattern/sequence'
require 'mtk/pattern/cycle'
require 'mtk/pattern/choice'
require 'mtk/pattern/function'
require 'mtk/pattern/lines'
require 'mtk/pattern/palindrome'

require 'mtk/sequencer/event_builder'
require 'mtk/sequencer/step_sequencer'

require 'mtk/_constants/pseudo_constants'
require 'mtk/_constants/pitch_classes'
require 'mtk/_constants/pitches'
require 'mtk/_constants/intervals'
require 'mtk/_constants/dynamics'

require 'mtk/numeric_extensions'


