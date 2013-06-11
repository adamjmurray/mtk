# Description of modules for documentation:

# The top level module for this library
module MTK

  # Internal helper classes used to avoid duplicating code in this library.
  module Helpers
  end

  # Musical events, such as {Events::Note}s and {Events::Parameter} changes, that are arranged in time via a {Timeline}.
  module Events
  end

  # Classes that emit elements one at a time. Used by {MTK::Sequencers::Sequencer}s to construct {Timeline}s.
  module Patterns
  end

  # Classes that assemble {Patterns::Pattern}s into {Timeline}s.
  module Sequencers
  end

  # Optional classes for the "MTK language", which let's you compose music via MTK without writing any Ruby code
  module Lang
  end

  # Collections of Core objects
  module Groups
  end

  # Optional classes for MIDI input and {Output}.
  module MIDI
  end

end

require 'mtk/pitch_class'
require 'mtk/pitch'
require 'mtk/duration'
require 'mtk/intensity'
require 'mtk/interval'

require 'mtk/lang/pseudo_constants'
require 'mtk/lang/pitch_classes'
require 'mtk/lang/pitches'
require 'mtk/lang/intervals'
require 'mtk/lang/intensities'
require 'mtk/lang/durations'
require 'mtk/lang/variable'
require 'mtk/lang/parser'

require 'mtk/groups/collection'
require 'mtk/groups/pitch_collection'
require 'mtk/groups/pitch_class_set'
require 'mtk/groups/melody'
require 'mtk/groups/chord'

require 'mtk/events/event'
require 'mtk/events/note'
require 'mtk/events/parameter'

require 'mtk/timeline'

require 'mtk/patterns/pattern'
require 'mtk/patterns/sequence'
require 'mtk/patterns/cycle'
require 'mtk/patterns/choice'
require 'mtk/patterns/function'
require 'mtk/patterns/lines'
require 'mtk/patterns/palindrome'
require 'mtk/patterns/chain'
require 'mtk/patterns/for_each'

require 'mtk/sequencers/event_builder'
require 'mtk/sequencers/sequencer'
require 'mtk/sequencers/step_sequencer'
require 'mtk/sequencers/rhythmic_sequencer'
require 'mtk/sequencers/legato_sequencer'
