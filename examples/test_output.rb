require 'mtk'
require_relative 'helpers/output_selector'
include MTK::Lang::Pitches

output = OutputSelector.ensure_output ARGV[0]

output.play MTK.Note(C4,2,1)
