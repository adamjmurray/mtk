require 'mtk/io/midi_output'
require 'mtk/lang/tutorial_step'

module MTK
  module Lang

    # @private
    class Tutorial

      def initialize(output)
        @output = output
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

              C D E F G A B
              ",
            validate: lambda{|input| input =~ /^\s*[A-G]\s*$/i },
          },
          {
              title: 'Pitch Classes (chromatic)',
              description: "
              To play a diatonic pitch class, enter any of the following letters: C D E F G A B
              (they can be upper-case or lower-case)
              ",
              validate: lambda{|input| input =~ /^\s*[A-G]\s*$/i },
              success:  lambda{|input| play input },
              failure:  lambda{|input| "Invalid entry: #{input}"}
          },
          {
              title: 'Pitches',
              description: "
                To play a pitch, enter a pitch class immediate following by an octave number
                For example, C4 is middle C. C-1 is the lowest note available, and G9 is the highest.
                ",
              validate: lambda{},
              success: lambda{},
              failure: lambda{}
          },
          {
              title: 'Sequences',
              description: "
                To play a sequence of pitches (or pitch classes), simply list them with spaces in between
                For example, C4 is middle C. C-1 is the lowest note available, and G9 is the highest.
                ",
              validate: lambda{},
              success: lambda{},
              failure: lambda{}
          },

        ].map{|step_options| TutorialStep.new(self, step_options) }
      end


      def run
        puts
        puts "Welcome to the MTK tutorial"
        puts "==========================="
        puts
        ensure_output
        loop{ select_step.run }
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
        puts "Tutorials"
        puts "---------"

        step = nil
        while step == nil
          puts toc
          puts
          puts "Press Ctrl+C to exit at any time."
          puts "Select a tutorial number, or hit enter to go to the next one (indicated by =>)."

          input = gets.strip
          step_index = case input
            when /^\d+$/ then input.to_i - 1
            when '' then @current_step_index
            else nil
          end

          step = @steps[step_index] if step_index and step_index >= 0

          puts "Invalid tutorial: #{input}\n\n" if step.nil?
        end

        @current_step_index = step_index + 1
        step
      end


      def play(mtk_syntax)
        sequencer = MTK::Lang::Parser.parse(mtk_syntax)
        if sequencer
          @output.play sequencer.to_timeline
        else
          STDERR.puts "Nothing to play for \"#{mtk_syntax}\""
        end
      rescue Citrus::ParseError
        STDERR.puts $!
      end


      #####################################################
      private

      def ensure_output
        if @output
          puts "Using \"#{@output.name}\" for output"
        else
          fail "--output option must be given"
          # TODO: select an output, explain --output option...
          # Or auto-select?
          #if defined? MTK::IO::DLSSynthDevice
          #  puts "It looks like you are on OS X so we'll try using the built-in 'DLS' synthesizer"
          #end
        end

      end

    end
  end
end