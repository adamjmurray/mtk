module MTK

  # Maps sorted times to lists of events.

  class Timeline

    # @param options [Hash] the options to create a Timeline with.
    # @option options [Hash] :from_hash the initial data for the timeline
    def initialize(options={})
      @timeline = {}
      hash = options[:from_hash]
      if hash
        hash = hash.to_hash unless hash.is_a? Hash
        for time,events in hash
          self[time] = events # ensures everything is wrapped in an Array
        end
      end
    end

    def self.from_hash(hash, options={})
      new options.merge({:from_hash => hash})
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
        events << event
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

    def map
      mapped_timeline = Timeline.new
      each_time do |time,events|
        mapped_timeline[time] = events.map{|event| yield time,event }
      end
      mapped_timeline
    end

    def map!
      each_time do |time,events|
        self[time] = events.map{|event| yield time,event }
      end
    end

    def clone
      self.class.from_hash(to_hash)
    end

    def compact!
      @timeline.delete_if {|t,events| events.empty? }
    end

    def to_s
      times.map{|t| "#{t} => #{@timeline[t].join ', '}" }.join "\n"
    end

    def inspect
      @timeline.inspect
    end

  end

end
