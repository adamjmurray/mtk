module MTK
  module Lang

    # @private
    class TutorialStep

      # Every TutorialStep requires the options at construction title:
      #   title - The short summary displayed in the tutorial's table of contents.
      #   description - The full description displayed when entering the tutorial step.
      #   validate(input) - Validate user input entered after the description is displayed.
      #   success(input) - Perform an action on successful validation
      #   failure(input) - Instruct the user on failed validation
      def initialize tutorial, options
        @tutorial = tutorial # handles playing output

        for attr in [:title, :description, :validate]
          instance_variable_set "@#{attr}", ( options[attr] || fail("#{attr} required in #{self.class}(#{options})") )
        end
        for attr in [:validate, :success, :failure]
          fail "#{attr} must be a Proc in #{self.class}(#{options})" unless options[attr].is_a? Proc or options[attr].nil?
        end

        @description = @description.split("\n").map{|line| line.strip }.join("\n") # trim extra whitespace
      end


      def run
        puts "================================================================="
        puts
        puts "Tutorial: #{@title}"
        puts @description
        puts
        puts "Try it now:"

        did_it_once = false
        input = gets.strip
        until did_it_once and input.empty?
          until @validate[input]
            failure(input)
            puts "Try again:"
            input = gets.strip
          end

          success(input)
          did_it_once = true
          puts
          puts "Good!"
          puts "Try again, or hit enter to exit this tutorial:"
          input = gets.strip
        end
      end


      def success(input)
        if @success
          @success.call(input)
        else
          @tutorial.play(input)
        end
      end


      def failure(input)
        if @failure
          @failure.call(input)
        else
          puts
          puts "Invalid entry \"#{input}\""
        end
      end


      def to_s
        @title
      end

    end

  end
end
