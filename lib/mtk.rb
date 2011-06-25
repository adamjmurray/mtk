##############################################
# Description of modules for documentation:

# The top level module for this library
module MTK

  # Classes for MIDI input and output
  module MIDI
  end

  # Classes that enumerate elements
  module Pattern
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

require 'mtk/_constants/pseudo_constants'
require 'mtk/_constants/pitch_classes'
require 'mtk/_constants/pitches'
require 'mtk/_constants/intervals'
require 'mtk/_constants/dynamics'

require 'mtk/numeric_extensions'


