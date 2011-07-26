module MTK

  # A collection of timed events. The core data structure used to interface with input and output.
  #
  # Maps sorted times to lists of events.
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
      alias from_hash from_a
    end

    def merge enumerable
      for time,events in enumerable
        add(time,events)
      end
      self
    end

    def clear
      @timeline.clear
      self
    end

    def to_hash
      @timeline
    end

    def == other
      other = other.to_hash unless other.is_a? Hash
      @timeline == other
    end

    def [](time)
      @timeline[time]
    end

    def []=(time, events)
      time = time.to_f unless time.is_a? Numeric
      case events
        when nil?
          @timeline.delete time
        when Array
          @timeline[time] = events
        else
          @timeline[time] = [events]
      end
    end

    def add(time, event)
      events = @timeline[time]
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
      @timeline.delete(time)
    end

    def has_time? time
      @timeline.has_key? time
    end

    def times
      @timeline.keys.sort
    end

    def empty?
      @timeline.empty?
    end

    def events
      times.map{|t| @timeline[t] }.flatten
    end

    def each
      # this is similar to @timeline.each, but by iterating over #times, we yield the events in chronological order
      for time in times
        yield time,@timeline[time]
      end
    end

    # the original Enumerable#map implementation, which returns an Array
    alias enumerable_map map

    # Constructs a new Timeline by mapping each [time,event_list] pair
    # @see #map!
    def map &block
      self.class.from_a(enumerable_map &block)
    end

    # Perform #map in place
    # @see #map
    def map! &block
      # we use the enumerable_map that aliased by the Mappable module,
      # because Mappable#map will create an extra timeline instance, which is unnecessary in this case
      mapped = enumerable_map &block
      clear
      merge mapped
    end

    # Map every individual event, without regard for the time at which is occurs
    def map_events
      mapped_timeline = Timeline.new
      for time,events in self
        mapped_timeline[time] = events.map{|event| yield event }
      end
      mapped_timeline
    end

    # Map every individual event in place, without regard for the time at which is occurs
    def map_events!
      for time,events in self
        self[time] = events.map{|event| yield event }
      end
    end

    def clone
      self.class.from_hash(to_hash)
    end

    def compact!
      @timeline.delete_if {|t,events| events.empty? }
    end
    
    def flatten
      flattened = Timeline.new
      for time,events in self
        for event in events
          if event.is_a? Timeline
            for subtime,subevent in event.flatten
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
      times.map{|t| "#{t} => #{@timeline[t].join ', '}" }.join "\n"
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
