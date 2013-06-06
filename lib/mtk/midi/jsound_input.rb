require 'jsound'

module MTK
  module MIDI

    # Provides realtime MIDI input for JRuby via the jsound gem.
    # @note This class is optional and only available if you require 'mtk/midi/jsound_input'.
    #       It depends on the 'jsound' gem.
    class JSoundInput < Input

      public_class_method :new

      def self.devices
        @devices ||= ::JSound::Midi::INPUTS.devices
      end

      def self.devices_by_name
        @devices_by_name ||= devices.each_with_object( Hash.new ){|device,hash| hash[device.description] = device }
      end


      attr_reader :device

      def initialize(input_device, options={})
        @device = input_device
        @recorder = ::JSound::Midi::Devices::Recorder.new(false)
        @device.open
      end

      def name
        @device.description
      end

      def record(options={})
        if options[:monitor]
          @monitor = ::JSound::Midi::Devices::Monitor.new
          @device >> [@monitor, @recorder]
        else
          @device >> @recorder
        end

        @recorder.clear
        @recorder.start
      end

      def stop
        @recorder.stop
      end

      def to_timeline(options={})
        bpm = options.fetch :bmp, 120
        beats_per_second = bpm.to_f/60
        timeline = Timeline.new
        note_ons = {}
        start = nil

        @recorder.messages_with_timestamps.each do |message,time|
          start = time unless start
          time -= start
          time /= beats_per_second

          case message.type
            when :note_on
              note_ons[message.pitch] = [message,time]

            when :note_off
              if note_ons.has_key? message.pitch
                note_on, start_time = note_ons.delete(message.pitch)
                duration = time - start_time
                note = MTK::Events::Note.from_midi(note_on.pitch, note_on.velocity, duration, message.channel)
                timeline.add time,note
              end

            else timeline.add time, MTK::Events::Parameter.from_midi([message.type, message.channel], message.data1, message.data2)
          end
        end

        timeline.quantize! options[:quantize] if options.key? :quantize
        timeline.shift_to! options[:shift_to] if options.key? :shift_to

        timeline
      end

    end
  end
end

