# Description of modules for documentation:

# The top level module for this library
module MTK

  # Core data types
  module Core
  end

  # Musical events, such as {MTK::Events::Note}s and {MTK::Events::Parameter} changes, that are arranged in time via a {MTK::Events::Timeline}.
  module Events
  end

  # Collections of {MTK::Core} objects
  module Groups
  end

  # Optional classes for MIDI {MTK::IO::File} and realtime MIDI {MTK::IO::Input} and {MTK::IO::Output}.
  module IO
  end

  # Optional classes for the "MTK language", which let's you compose music via MTK without writing any Ruby code
  module Lang
  end

  # Classes that emit elements one at a time. Used by {MTK::Sequencers::Sequencer}s to construct {MTK::Events::Timeline}s.
  module Patterns
  end

  # Classes that assemble {MTK::Patterns::Pattern}s into {MTK::Events::Timeline}s.
  module Sequencers
  end

end

require 'mtk/core/pitch_class'
require 'mtk/core/pitch'
require 'mtk/core/duration'
require 'mtk/core/intensity'
require 'mtk/core/interval'

require 'mtk/lang/pseudo_constants'
require 'mtk/lang/pitch_classes'
require 'mtk/lang/pitches'
require 'mtk/lang/intervals'
require 'mtk/lang/intensities'
require 'mtk/lang/durations'
require 'mtk/lang/variable'
require 'mtk/lang/parser'

require 'mtk/groups/group'
require 'mtk/groups/pitch_class_group'
require 'mtk/groups/pitch_class_set'
require 'mtk/groups/pitch_group'
require 'mtk/groups/chord'
require 'mtk/groups/interval_group'

require 'mtk/events/event'
require 'mtk/events/note'
require 'mtk/events/rest'
require 'mtk/events/parameter'
require 'mtk/events/timeline'

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
