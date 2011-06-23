module MTK

  # A collection of timed events.
  #
  # Maps sorted times to lists of events.
  #
  # Enumerable as |time,event| pairs.
  #
  class Timeline

    include Transform::Mappable

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

    def map! &block
      mapped = enumerable_map &block
      clear
      merge mapped
    end

    def map_events
      mapped_timeline = Timeline.new
      for time,events in self
        mapped_timeline[time] = events.map{|event| yield event }
      end
      mapped_timeline
    end

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
      quantized = Timeline.new
      each do |time,events|
        qtime = self.class.quantize_time(time,interval)
        quantized[qtime] = events
      end
      quantized
    end

    def quantize! interval
      each do |time,events|
        qtime = self.class.quantize_time(time,interval)
        if time != qtime
          delete time
          add qtime,events  # need to add, since we may quantize forward to a time that already has events
        end
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
