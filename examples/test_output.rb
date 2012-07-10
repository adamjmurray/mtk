require 'mtk'
require 'mtk/helper/output_selector'
include MTK
include Constant::Pitches

output = Helper::OutputSelector.ensure_output ARGV[0]

output.play Note(C4,1,2)
