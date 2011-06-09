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
require 'mtk/transform/mappable'
require 'mtk/transform/transposable'
require 'mtk/transform/invertible'

require 'mtk/pitch_class'
require 'mtk/pitch_class_set'
require 'mtk/pitch'
require 'mtk/pitch_set'

require 'mtk/event'
require 'mtk/note'
require 'mtk/chord'
require 'mtk/timeline'

require 'mtk/constants/pseudo_constants'
require 'mtk/constants/pitch_classes'
require 'mtk/constants/pitches'
require 'mtk/constants/intervals'
require 'mtk/constants/dynamics'

require 'mtk/numeric_extensions'


