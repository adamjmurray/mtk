module MTK

  module Event

    class Parameter < AbstractEvent

      def initialize(type, value, number=nil)
        super(type,value,0,number)
      end

      def self.from_midi(status, data1, data2)
        channel = status & 0x0F # TODO: store channel in events
        type, number, value = *(
          case status & 0xF0
            when 0xA0 then [:pressure, data1, data2]
            when 0xB0 then [:control, data1, data2]
            when 0xC0 then [:program, data1]
            when 0xD0 then [:pressure, nil, data1] # no number means all notes on channel
            when 0xE0 then [:bend, nil, (data1 + (data2 << 7))]
            else [:unknown, data1, data2]
          end
        )
        new type, value, number  # TODO: channel
      end

      def to_s
        "Parameter(#@type" + (@number ? "[#@number]," : ',') + (@value.is_a?(Fixnum) ? @value.to_s : "#{sprintf '%.2f',@value}") + ')'
      end

      def inspect
        "Parameter(#@type" + (@number ? "[#@number]:" : ':') + "#@value)"
      end

    end

  end
end