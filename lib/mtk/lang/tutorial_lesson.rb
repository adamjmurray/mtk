module MTK
  module Lang

    # @private
    class TutorialLesson

      SEPARATOR = "================================================================================\n\n"


      # Every TutorialStep requires the options at construction title:
      #   title - The short summary displayed in the tutorial's table of contents.
      #   description - The full description displayed when entering the tutorial step.
      #   validate(input) - Validate user input entered after the description is displayed.
      #   success(input) - Perform an action on successful validation
      #   failure(input) - Instruct the user on failed validation
      def initialize options
        @title = options[:title]
        @description = options[:description].split("\n").map{|line| line.strip }.join("\n") # trim extra whitespace
        @validation = options[:validation]
      end


      def run(output)
        puts SEPARATOR
        puts "Lesson: #{@title}"
        puts @description
        puts
        print "Try it now: "

        did_it_once = false
        input = gets.strip
        until did_it_once and input.empty?
          until validate(input)
            failure(input)
            print "Try again: "
            input = gets.strip
          end

          success(input, output)
          did_it_once = true
          puts
          puts "Good! Try again, or hit enter to exit this tutorial:"
          input = gets.strip
        end
      end


      def validate(input)
        return false if input.empty?

        case @validation
          when Symbol
            MTK::Lang::Parser.parse(input, @validation)
            true
          else # Assume Regexp
            (input =~ /^[A-G]$/i) != nil
        end
      rescue Citrus::ParseError
        false
      end


      def success(input, output)
        sequencer = MTK::Lang::Parser.parse(input)
        if sequencer
          output.play sequencer.to_timeline
        else
          STDERR.puts "Nothing to play for \"#{input}\""
        end
      rescue Citrus::ParseError
        STDERR.puts $!
      end


      def failure(input)
        puts
        puts "Invalid entry \"#{input}\""
      end


      def to_s
        @title
      end

    end

  end
end
