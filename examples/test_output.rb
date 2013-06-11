require 'mtk'
require 'mtk/io/output_selector'
include MTK::Lang::Pitches

output = MTK::IO::OutputSelector.ensure_output ARGV[0]

output.play MTK.Note(C4,1,2)
