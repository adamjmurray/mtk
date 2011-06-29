module MTK
  module Pattern

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence < AbstractPattern
      include Collection

      # Reset the sequence to the beginning
      def rewind
        @index = -1
        super
      end

      ###################
      protected

      # (see AbstractPattern#advance!)
      def advance!
        @index += 1
        raise StopIteration if @elements.nil? or @index >= @elements.length
      end

      # (see AbstractPattern#current)
      def current
        @elements[@index]
      end
    end

    def Sequence(*anything)
      Sequence.new(anything)
    end
    module_function :Sequence

    def PitchSequence(*anything)
      Sequence.new(anything, :type => :pitch)
    end
    module_function :PitchSequence

    def IntensitySequence(*anything)
      Sequence.new(anything, :type => :intensity)
    end
    module_function :IntensitySequence

    def DurationSequence(*anything)
      Sequence.new(anything, :type => :duration)
    end
    module_function :DurationSequence


  end
end
