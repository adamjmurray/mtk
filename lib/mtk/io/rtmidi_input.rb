require 'rtmidi'
require 'ostruct'

module MTK
  module IO

    # Provides realtime MIDI input for "standard" Ruby (MRI) via the rtmidi gem.
    # @note This class will be loaded if available when you require 'mtk/io/midi_input'.
    #       It depends on the 'rtmidi' gem.
    class RtMidiInput < MIDIInput

      public_class_method :new

      def self.devices
        @devices ||= devices_by_name.map{|key,value| OpenStruct.new(name:key, port_index:value) }
      end

      def self.devices_by_name
        @devices_by_name ||= (
          @midiin = RtMidi::In.new
          hash = {}
          @midiin.port_names.each_with_index{|name,index| hash[name] = index }
          hash
        )
      end


      attr_reader :device

      def initialize(device_id, options={})
        if device_id.respond_to? :port_index
          port_index = device_id.port_index
        else
          port_index = device_id
        end
        @device = RtMidi::In.new
        @name = @device.port_name(port_index)
        @options = options

        @device.open_port(port_index)
      end

      def name
        @name
      end

      def record(options={})
        @recording = [] unless options[:append] and @recording
        monitor = options[:monitor]

        # TODO: implementation seems messy, probably needs a major revamp
        unless @trapping
          @trapping = true
          trap("SIGINT") do
            if @thread and @thread.alive?
              stop
            else
              raise SystemExit
            end
          end
        end

        stop
        @thread = Thread.new do
          @start_time = Time.now.to_f
          @device.set_callback do |byte1, byte2, byte3|
            puts "#{@name}: #{byte1} #{byte2} #{byte3}" if monitor
            record_raw_data byte1,byte2,byte3
          end
          loop{ sleep 1 }
        end

        time_limit = options[:time_limit]
        if time_limit
          puts "Blocking current thread for #{time_limit} seconds to record MIDI input."
          @thread.join(time_limit)
          stop
        else
          puts "Recording MIDI input. Press Ctrl+C to stop."
          @thread.join
        end
      end

      def stop
        Thread.kill @thread if @thread
        @device.cancel_callback
      end

      def to_timeline(options={})
        return nil if not @recording

        bpm = options.fetch :bmp, 120
        beats_per_second = bpm.to_f/60
        timeline = MTK::Events::Timeline.new
        note_ons = {}
        start = nil

        @recording.each do |message, time|
          start ||= time
          time -= start
          time /= beats_per_second

          if message.is_a? MTK::Events::Event
            timeline.add time,message unless message.type == :unknown
          else
            message_type = message.type
            message_type = :note_off if message_type == :note_on and message.velocity == 0
            # TODO: this will need to be made more robust when we support off velocities

            case message_type
              when :note_on
                pitch = message.pitch
                note_ons[pitch] = [message,time]

              when :note_off
                pitch = message.pitch
                if note_ons.has_key? pitch
                  note_on, start_time = note_ons.delete(pitch)
                  duration = time - start_time
                  note = MTK::Events::Note.from_midi pitch, note_on.velocity, duration
                  timeline.add time,note
                end
            end
          end
        end

        timeline.quantize! options[:quantize] if options.key? :quantize
        timeline.shift_to! options[:shift_to] if options.key? :shift_to

        timeline
      end


      #######################
      private

      def record_raw_data status, data1, data2
        message = case status & 0xF0
          when 0x80 then OpenStruct.new({:type => :note_off, :pitch => data1, :velocity => data2})
          when 0x90 then OpenStruct.new({:type => :note_on,  :pitch => data1, :velocity => data2})
          else MTK::Events::Parameter.from_midi(status,data1,data2)
        end
        time = Time.now.to_f - @start_time
        @recording << [message, time]
      rescue
        STDERR.put "#{self.class}: Error while recording! #{$!}"
      end

    end
  end
end

