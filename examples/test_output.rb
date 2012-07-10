require 'mtk'
require 'mtk/helper/output_selector'

output = MTK::Helper::OutputSelector.ensure_output ARGV[0]
timeline = MTK::Timeline.from_hash 0 => MTK::Note(MTK::Constant::Pitches::C4,1,2)
output.play( timeline )