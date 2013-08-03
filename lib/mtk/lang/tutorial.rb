require 'mtk/io/midi_output'
require 'mtk/lang/tutorial_step'

module MTK
  module Lang

    # @private
    class Tutorial

      def initialize
        @current_step_index = 0

        @steps = [
              ###################### 80 character width for description ######################
          {
            title: 'Pitch Classes (diatonic)',
            description: "
              The diatonic pitch classes are the 7 white keys on a piano in a given octave.
              They can be used to play, for example, the C major or A natural minor scales.

              To play a diatonic pitch class, enter one of the following letters
              (upper or lower case is allowed):

              C D E F G A B   c d e f g a b
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
              lowers the pitch by a semitone and each sharp (#) raises by a semitone.

              Here are some examples (Note, upper or lower case is allowed for the diatonic
              pitch class but flats must be lower case):

              C# Eb F Gbb A## B   c# eb f gbb a## b
              ",
            validation: :pitch_class,
          },
          {
              title: 'Pitches',
              description: "
                To play a pitch, enter a (chromatic) pitch class immediate following by an
                octave number.

                There is no universal standard numbering scheme for octaves in music.
                This library uses \"scientific pitch notation\", which defines
                C4 as \"Middle C\" and A4 as the standard tuning pitch A440.

                In this library, C-1 is the lowest note available and G9 is the highest,
                corresponding to MIDI pitch values 0 and 127. If you try to play a pitch
                outside this range, it will be mapped to the closest available pitch.

                Here are some examples:

                G3 eb4 F#5 B-1 C##9 dbb6
                ",
              validation: :pitch,
          },
          {
              title: 'Sequences',
              description: "
                To play a sequence of pitches or pitch classes, simply list them with spaces in between.
                Pitches and pitch classes may be interchanged in a given sequence. Any pitch class will
                output a pitch closest to the previous pitch (starting from C4 at the beginning of the sequence).

                Here is an example (Note, unlike previous tutorials, enter the entire line):

                c5 c g5 g a a g
                ",
              validation: :bare_sequence,
          },

        ].map{|step_options| TutorialStep.new(step_options) }
      end


      def run(output)
        puts
        puts TutorialStep::SEPARATOR
        puts "Welcome to the MTK syntax tutorial!"
        puts
        puts "MTK is the Music Tool Kit for Ruby."
        puts "It has a custom syntax for generating musical patterns."
        puts "This tutorial will teach you the basics."
        puts
        puts "Warning! This tutorial assumes familiarity with music theory."
        puts "This is a work in progress. Check back in future versions for more tutorials."

        output = ensure_output(output)
        loop{ select_step.run(output) }

      rescue SystemExit, Interrupt
        puts
        puts
        puts "Goodbye!"
        puts
      end


      # table of contents
      def toc
        @steps.map.with_index{|step,index| "#{'=> ' if @current_step_index == index}#{index+1}: #{step}"}.join("\n")
      end


      def select_step
        puts
        puts TutorialStep::SEPARATOR
        puts "Tutorials"
        puts "---------"

        all_done = @current_step_index >= @steps.length
        step = nil
        while step == nil
          puts toc
          puts
          puts "You've completed the last tutorial!\n\n" if all_done
          puts "Press Ctrl+C to exit at any time."
          print "Select a tutorial number, or hit enter to "
          puts (if all_done then "exit:" else "go to the next one (indicated by =>):" end)

          input = gets.strip
          step_index = case input
            when /^\d+$/
              input.to_i - 1
            when ''
              if all_done then raise SystemExit.new else @current_step_index end
            else
              nil
          end

          step = @steps[step_index] if step_index and step_index >= 0

          puts "Invalid tutorial: #{input}\n\n" if step.nil?
        end

        @current_step_index = step_index + 1
        step
      end


      #####################################################
      private

      def ensure_output(output)
        if output
          #puts "Using \"#{output.name}\" for output."
        else
          puts "ERROR: --output option must be given when launching the tutorial."
          exit 1
          # TODO: select an output, explain --output option...
          # Or auto-select?
          #if defined? MTK::IO::DLSSynthDevice
          #  puts "It looks like you are on OS X so we'll try using the built-in 'DLS' synthesizer"
          #end
        end
        output
      end

    end
  end
end