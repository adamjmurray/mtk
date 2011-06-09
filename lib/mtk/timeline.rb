module MTK

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

    def map! &block
      mapped = enumerable_map &block
      clear
      merge mapped
    end

    def map_events
      mapped_timeline = Timeline.new
      each_time do |time,events|
        mapped_timeline[time] = events.map{|event| yield event }
      end
      mapped_timeline
    end

    def map_events!
      each_time do |time,events|
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
      for time,event in self
        if event.is_a? Timeline
          for subtime, subevent in event.flatten
            flattened.add(time+subtime, subevent)
          end
        else
          flattened.add(time,event)
        end
      end
      flattened
    end

    def to_s
      times.map{|t| "#{t} => #{@timeline[t].join ', '}" }.join "\n"
    end

    def inspect
      @timeline.inspect
    end

  end

end
