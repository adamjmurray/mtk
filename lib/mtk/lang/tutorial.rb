# encoding: UTF-8

require 'mtk/io/midi_output'
require 'mtk/lang/tutorial_lesson'

module MTK
  module Lang

    # @private
    class Tutorial

      def initialize
        @current_lesson_index = 0

        @lessons = [
              ###################### 79 character width for description #####################
          {
            title: 'Pitch Classes (diatonic)',
            description: "
              The diatonic pitch classes are the 7 white keys on a piano in a given octave.
              They can be used to play, for example, the C major or A natural minor scales.

              To play a diatonic pitch class, enter #{'one'.bold.underline} of the following letters:

              C D E F G A B
              ",
            validation: :diatonic_pitch_class,
          },
          {
            title: 'Pitch Classes (chromatic)',
            description: "
              The chromatic pitch classes are the 12 white or black keys on a piano in a
              given octave. They form the basis of all 'western' music theory.

              To play a chromatic pitch class, enter any of the 7 diatonic pitch classes
              immediately followed by 0, 1, or 2 flats (b) or sharps (#). Each flat (b)
              lowers the pitch by a half step and each sharp (#) raises by a half step.

              Here are some examples, try entering #{'one'.bold.underline} of the following:

              C# Bb A## Ebb F
              ",
            validation: :pitch_class,
          },
          {
            title: 'Pitches',
            description: "
              To play a pitch, enter a (chromatic) pitch class immediately following by an
              octave number.

              There is no universal standard numbering scheme for octaves in music.
              This library uses \"scientific pitch notation\", which defines
              C4 as \"Middle C\" and A4 as the standard tuning pitch A440.

              In this library, C-1 is the lowest note available and G9 is the highest,
              corresponding to MIDI pitch values 0 and 127. If you try to play a pitch
              outside this range, it will be mapped to the closest available pitch.

              Here are some examples, try entering #{'one'.bold.underline} of the following:

              G3 Eb4 F#5 B-1 C##9 Dbb6
              ",
            validation: :pitch,
          },
          {
            title: 'Sequences',
            description: "
              To play a sequence of pitches or pitch classes, enter them with spaces in
              between. Pitches and pitch classes may be interchanged in a given sequence.
              Any pitch class will output a pitch closest to the previous pitch (starting
              from C4 at the beginning of the sequence).

              Here is an example (Note, unlike previous lessons, enter the #{'entire line'.bold.underline}):

              C5 C G5 G A A G
              ",
            validation: :bare_sequence,
          },
          {
            title: 'Repetition',
            description: "
              To repeat a note, suffix a pitch or pitch class with *N, where N is the
              number of repetitions. You can also wrap a subsequence of notes with
              parentheses and repeat them. Here is an example sequence with repetition:

              C*3 D (E D)*2 C

              You can also nest repetitions (optional whitespace added for readability):

              ( C5 (E G)*2 )*2
              ",
            validation: /\*/,
          },

        ].map{|lesson_options| TutorialLesson.new(lesson_options) }
      end


      def run(output)
        puts SEPARATOR
        puts
        puts "Welcome to the MTK syntax tutorial!".bold.yellow
        puts
        puts "MTK is the Music Tool Kit for Ruby, which includes a custom syntax for"
        puts "generating musical patterns. This tutorial has a variety of lessons to teach"
        puts "you the syntax. It assumes basic familiarity with music theory."
        puts
        puts "Make sure your speakers are on and the volume is turned up."
        puts
        puts "This is a work in progress. Check back in future versions for more lessons."
        puts
        puts "#{'NOTE:'.bold} MTK syntax is case-sensitive. Upper vs lower-case matters."
        puts

        output = ensure_output(output)
        loop{ select_lesson.run(output) }

      rescue SystemExit, Interrupt
        puts
        puts
        puts "Goodbye!"
        puts
      end


      # table of contents
      def toc
        @lessons.map.with_index do |lesson,index|
          "#{'> '.bold.yellow if @current_lesson_index == index}#{index+1}: #{lesson}"
        end.join("\n")
      end


      def select_lesson
        puts
        puts SEPARATOR
        puts
        puts "Lessons".bold.yellow
        puts

        all_done = @current_lesson_index >= @lessons.length
        lesson = nil
        while lesson == nil
          puts toc
          puts
          if all_done
            puts "You've completed the last lesson!"
            puts "To explore more, try running #{$0} with the --eval option."
            puts
          end
          puts "Press Ctrl+C to exit at any time.".bold
          puts
          print "Select a lesson number, or press enter to ".blue
          if all_done
            puts "exit:".blue
          else
            puts "go to the next one ".blue + "(indicated by " + '>'.bold.yellow + "):"
          end

          input = gets.strip
          lesson_index = case input
            when /^\d+$/
              input.to_i - 1
            when ''
              if all_done then raise SystemExit.new else @current_lesson_index end
            else
              nil
          end

          lesson = @lessons[lesson_index] if lesson_index and lesson_index >= 0

          puts "Invalid lesson number: #{input}\n\n" if lesson.nil?
        end

        @current_lesson_index = lesson_index + 1
        lesson
      end


      #####################################################
      private

      def ensure_output(output)
        unless output
          puts SEPARATOR
          puts
          puts "Select an output".bold.yellow
          puts
          puts "You need to select a MIDI output device before you can hear sound."
          puts

          require 'rbconfig'
          case RbConfig::CONFIG['host_os'].downcase
            when /darwin/
              puts "You appear to be on OS X."
              puts "You can use the \"Apple DLS Synthesizer\" to hear sound with no extra setup."
              puts "It's recommended you use this unless you have a good reason to do otherwise."
            when /win/
              puts "You appear to be on Windows"
              puts "You can use the \"Microsoft Synthesizer\" to hear sound with no extra setup."
              puts "It's recommended you use this unless you have a good reason to do otherwise."
          end

          until output
            puts
            puts "Available MIDI outputs:".bold.yellow
            MTK::IO::MIDIOutput.devices.each.with_index do |device,index|
              name = device.name
              name += " (#{device.id})" if device.respond_to? :id
              puts "#{index+1}: #{name}"
            end

            puts "Select an output number:".blue

            input = STDIN.gets.strip
            if input =~ /^\d+$/
              number = input.to_i
              if number > 0
                device = MTK::IO::MIDIOutput.devices[number-1]
                output = MTK::IO::MIDIOutput.open(device) if device
              end
            end

            puts "Invalid selection.".red unless device
          end

          puts
          puts "OK! Using output '#{output.name}'".bold.green
          puts "#{'NOTE:'.bold} You can skip the output selection step in the future by running "
          puts "#{$0} with the --output option."
          puts "Press enter to continue".blue
          gets
        end
        output
      end

    end
  end
end


####################################################################################################
# Patch String to support terminal colors

# @private
class String
  {
    bold: 1,
    underline: 4,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 36 # really this cyan but the standard blue is too dark IMO
  }.each do |effect,code|
    if $tutorial_color
      define_method effect do
        "\e[#{code}m#{self}\e[0m"
      end
    else
      define_method effect do
        self
      end
    end
  end

end


####################################################################################################
# And now that we've got some colors we can define colored constants
module MTK
  module Lang
    # @private
    class Tutorial
      SEPARATOR = "===============================================================================".bold.yellow
    end
  end
end
