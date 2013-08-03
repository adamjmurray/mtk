module MTK

  module Events

    # A non-note event such as pitch bend, pressure (aftertouch), or control change (CC)
    class Parameter < Event

      def self.from_midi(status, data1, data2)
        if status.is_a? Array
          type,channel = *status
        else
          type,channel = status & 0xF0, status & 0x0F
        end
        type, number, value = *(
          case type
            when 0xA0,:poly_pressure    then [:pressure, data1, data2]
            when 0xB0,:control_change   then [:control, data1, data2]
            when 0xC0,:program_change   then [:program, data1]
            when 0xD0,:channel_pressure then [:pressure, nil, data1] # no number means all notes on channel
            when 0xE0,:pitch_bend       then [:bend, nil, (data1 + (data2 << 7))]
            else [:unknown, data1, data2]
          end
        )
        if type == :bend
          if value == 16383
            value = 1.0 # special case since the math doesn't quite work out to convert to -1..1 for all values
          else
            value = (value / 8192.0) - 1.0
          end
        elsif value.is_a? Numeric
          value /= 127.0
        end
        new type, :number => number, :value => value, :channel => channel
      end

      def midi_value
        if @type == :bend
          (16383*(@value+1)/2).round
        else
          super
        end
      end

      def to_s
        "Parameter(#@type" + (@number ? "[#@number], " : ', ') + "#{sprintf '%.2f', @value || Float::NAN})"
      end

      def inspect
        "Parameter(#@type" + (@number ? "[#@number], " : ', ') + "#@value)"
      end

    end

  end
end