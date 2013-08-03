module MTK
  module Events

    # A collection of timed events. The core data structure used to interface with input and output.
    #
    # Maps sorted floating point times to lists of events.
    #
    # Enumerable as [time,event_list] pairs.
    #
    class Timeline
      include Enumerable

      def initialize()
        @timeline = {}
      end

      class << self
        def from_a(enumerable)
          new.merge enumerable
        end
        alias from_h from_a
      end

      def merge enumerable
        enumerable.each do |time,events|
          add(time,events)
        end
        self
      end

      def clear
        @timeline.clear
        self
      end

      def to_h
        @timeline
      end

      def == other
        other = other.to_h unless other.is_a? Hash
        @timeline == other
      end

      def [](time)
        @timeline[time.to_f]
      end

      def []=(time, events)
        time = time.to_f unless time.is_a? Numeric
        case events
          when nil?
            @timeline.delete time.to_f
          when Array
            @timeline[time.to_f] = events
          else
            @timeline[time.to_f] = [events]
        end
      end

      def add(time, event)
        events = @timeline[time.to_f]
        if events
          if event.is_a? Array
            events.concat event
          else
            events << event
          end
        else
           self[time] = event
        end
      end

      def delete(time)
        @timeline.delete(time.to_f)
      end

      def has_time? time
        @timeline.has_key? time.to_f
      end

      def times
        @timeline.keys.sort
      end

      def length
        last_time = times.last
        events = @timeline[last_time]
        last_time + events.map{|event| event.duration }.max
      end

      def empty?
        @timeline.empty?
      end

      def events
        times.map{|t| @timeline[t] }.flatten
      end

      def each
        # this is similar to @timeline.each, but by iterating over #times, we yield the events in chronological order
        times.each do |time|
          yield time, @timeline[time]
        end
      end

      # the original Enumerable#map implementation, which returns an Array
      alias enumerable_map map

      # Constructs a new Timeline by mapping each [time,event_list] pair
      # @see #map!
      def map &block
        self.class.from_a enumerable_map(&block)
      end

      # Perform #map in place
      # @see #map
      def map! &block
        mapped = enumerable_map(&block)
        clear
        merge mapped
      end

      # Map every individual event, without regard for the time at which is occurs
      def map_events
        mapped_timeline = Timeline.new
        self.each do |time,events|
          mapped_timeline[time] = events.map{|event| yield event }
        end
        mapped_timeline
      end

      # Map every individual event in place, without regard for the time at which is occurs
      def map_events!
        each do |time,events|
          self[time] = events.map{|event| yield event }
        end
      end

      def clone
        self.class.from_h(to_h)
      end

      def compact!
        @timeline.delete_if {|t,events| events.empty? }
      end

      def flatten
        flattened = Timeline.new
        self.each do |time,events|
          events.each do |event|
            if event.is_a? Timeline
              event.flatten.each do |subtime,subevent|
                flattened.add(time+subtime, subevent)
              end
            else
              flattened.add(time,event)
            end
          end
        end
        flattened
      end

      # @return a new Timeline where all times have been quantized to multiples of the given interval
      # @example timeline.quantize(0.5)  # quantize to eight notes (assuming the beat is a quarter note)
      # @see quantize!
      def quantize interval
        map{|time,events| [self.class.quantize_time(time,interval), events] }
      end

      def quantize! interval
        map!{|time,events| [self.class.quantize_time(time,interval), events] }
      end

      # shifts all times by the given amount
      # @see #shift!
      # @see #shift_to
      def shift time_delta
        map{|time,events| [time+time_delta, events] }
      end

      # shifts all times in place by the given amount
      # @see #shift
      # @see #shift_to!
      def shift! time_delta
        map!{|time,events| [time+time_delta, events] }
      end

      # shifts the times so that the start of the timeline is at the given time
      # @see #shift_to!
      # @see #shift
      def shift_to absolute_time
        start = times.first
        if start
          shift absolute_time - start
        else
          clone
        end
      end

      # shifts the times in place so that the start of the timeline is at the given time
      # @see #shift_to
      # @see #shift!
      def shift_to! absolute_time
        start = times.first
        if start
          shift! absolute_time - start
        end
        self
      end

      def to_s
        times = self.times
        last = times.last
        if last
          width = sprintf("%d",last).length + 3 # nicely align the '=>' against the longest number
          times.map{|t| sprintf("%#{width}.2f",t)+" => #{@timeline[t].join ', '}" }.join "\n"
        else
          ''
        end
      end

      def inspect
        @timeline.inspect
      end

      def self.quantize_time time, interval
        upper = interval * (time.to_f/interval).ceil
        lower = upper - interval
        (time - lower) < (upper - time) ? lower : upper
      end

    end

  end
end
