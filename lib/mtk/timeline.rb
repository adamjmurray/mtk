module MTK

  # Maps timepoints to lists of events

  class Timeline

    def initialize(timeline_hash=nil)
      @timeline = Hash.new{ |hash, key| hash[key] = [] }
      if timeline_hash
        # we do it this way to ensure everything is wrapped in an Array
        for time, event_or_events in timeline_hash
          self[time] = event_or_events
        end
      end
    end

    def [](time)
      @timeline[time]
    end

    def[]=(time, event_or_events)
      if event_or_events.is_a? Array
        @timeline[time] = event_or_events
      else
        @timeline[time] = [event_or_events]
      end
    end

    def has_timepoint? timepoint
      @timeline.has_key? timepoint and not @timeline[timepoint].empty?
    end

    def timepoints
      @timeline.keys.reject{|timepoint| @timeline[timepoint].empty? }.sort
    end

    def to_hash
      @timeline
    end

  end

end
