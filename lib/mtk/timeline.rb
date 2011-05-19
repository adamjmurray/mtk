module MTK

  # Maps sorted times to lists of events.

  class Timeline

    def initialize(timeline=nil)
      @timeline = {}
      if timeline
        timeline = timeline.to_hash unless timeline.is_a? Hash
        for time,events in timeline
          self[time] = events # ensures everything is wrapped in an Array
        end
      end
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

    def has_time? time
      @timeline.has_key? time
    end

    def times
      @timeline.keys.sort
    end

    def events
      times.map{|t| @timeline[t] }.flatten
    end

    def each
      times.each do |time|
        events = @timeline[time]
        events.each do |event|
          yield time,event
        end
      end
    end

    def each_time
      times.each do |time|
        events = @timeline[time]
        yield time,events
      end
    end

    def compact!
      @timeline.delete_if {|t,events| events.empty? }
    end

    def to_s
      times.map{|t| "#{t} => #{@timeline[t].join ', '}" }.join "\n"
    end

  end

end
