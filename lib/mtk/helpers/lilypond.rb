require 'tempfile'
require 'tmpdir'
require 'fileutils'

module MTK
  module Helpers

    # Uses {Timeline}s to generates music notation graphics with {http://lilypond.org/ Lilypond}.
    # @note This class is optional and only available if you require 'mtk/helpers/lilypond'.
    # @note To make notation graphics, {http://lilypond.org/download.html Lilypond} must be installed
    #       and you must follow the "Running on the command-line" instructions (found on the download page for
    #       your operating system). If the lilypond command is not on your PATH, set the environment variable LILYPOND_PATH
    class Lilypond

      LILYPOND_PATH = ENV['LILYPOND_PATH'] || 'lilypond'

      VALID_FORMATS = %w( png pdf ps )


      def initialize(file, options={})
        @file = file
        @options = options

        @format = File.extname(file)[1..-1].downcase
        raise ArgumentError.new("Invalid file format '#{@format}'") unless VALID_FORMATS.include? @format

        @dpi = options[:dpi]
      end

      def self.open(file, options={})
        new(file,options)
      end


      def write(timeline)
        lilypond_syntax = syntax_for_timeline(timeline)
        puts lilypond_syntax
        puts "_____________________________"
        Tempfile.open('mtk_lilypond') do |lilypond_file|
          Dir.mktmpdir do |tmpdir|
            # use the directory...
            #open("#{dir}/foo", "w") { ... }

            lilypond_file.write(lilypond_syntax)
            lilypond_file.flush

            cmd = ['lilypond', '-dbackend=eps', "-f#{@format}", "--output=\"#{tmpdir}\""]
            cmd << "-dresolution=#{@dpi}" if @dpi
            cmd << lilypond_file.path
            cmd = cmd.join(' ')

            puts cmd if $DEBUG
            lilypond_command_output = `#{cmd}`
            puts lilypond_command_output if $DEBUG

            output_file = Dir["#{tmpdir}/*.#{@format}"].first

            FileUtils.cp output_file, @file

            puts "Wrote #{@file}"
          end
        end
      end


      ########################
      private

      QUANTIZATION_INTERVAL = 0.0625 # 64th note granularity

      SYNTAX_PREFIX = '
      \language "english"
      \paper{
        oddFooterMarkup=##f
        oddHeaderMarkup=##f
      }
      \new PianoStaff {
        \autochange {
      '

      SYNTAX_SUFFIX = '
        }
      }
      '

      def syntax_for_timeline(timeline)
        quantized_timeline = timeline.flatten.quantize(QUANTIZATION_INTERVAL)
        last_time = 0
        last_duration = 0

        s = ''
        s << SYNTAX_PREFIX

        for time,events in quantized_timeline

          # handle rests between notes
          delta = time - last_time
          if delta > last_duration
            s << 'r'+syntax_for_duration(delta - last_duration)
            s << ' '
          end

          notes = events.find_all{|event| event.type == :note }

          if notes.length > 1
            # a chord
            s << '<'
            total_duration = 0
            for note in notes
              total_duration += note.duration
              s << syntax_for_pitch(note.pitch)
              s << ' '
            end
            s << '>'
            duration = total_duration.to_f/notes.length
            s << syntax_for_duration(duration)

          else # a single note
            note = notes.first
            s << syntax_for_pitch(note.pitch)
            duration = note.duration
            s << syntax_for_duration(duration)
          end

          last_time = time
          last_duration = duration
          s << ' '
        end

        s << SYNTAX_SUFFIX
        s
      end

      def syntax_for_pitch(pitch)
        syntax = pitch.pitch_class.name.downcase
        if syntax.length > 0
          syntax = syntax[0] + syntax[1..-1].gsub('b','f') # .gsub('#','s') pitch class names never have '#'
        end
        oct = pitch.octave
        while oct > 3
          syntax << "'"
          oct -= 1
        end
        while oct < 3
          syntax << ","
          oct += 1
        end
        syntax
      end

      def syntax_for_duration(duration)
        # TODO: handle dots, triplets, and ties of arbitrary durations
        duration = MTK::Timeline.quantize_time(duration.to_f.abs, QUANTIZATION_INTERVAL)
        syntax = (4.0/duration).round
        syntax = 1 if syntax < 1
        syntax.to_s
      end

    end

  end
end