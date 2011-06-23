require 'rubygems'
require 'jsound'

# TODO: fix jsound instead of monkey patching
class JSound::Midi::Devices::Recorder
  def message(message)
    @messages_with_timestamps << [message, Time.now.to_f] if recording?
  end
end


# Provides MIDI input and output for JRuby via the jsound gem
module MTK
  module MIDI

    class JSoundInput

      def initialize(input_device)
        if input_device.is_a? ::JSound::Midi::Device
          @input = input_device
        else
          @input = ::JSound::Midi::INPUTS.send input_device
        end
        @recorder = ::JSound::Midi::Devices::Recorder.new(false)
        @input >> @recorder
      end

      def record
        @input.open
        @recorder.clear
        @recorder.start
      end

      def stop
        @recorder.stop
        @input.close
      end

      def to_timeline(options={})
        bpm = options.fetch :bmp, 60
        beats_per_second = bpm.to_f/60
        timeline = Timeline.new
        note_ons = {}
        start = nil

        for message,time in @recorder.messages_with_timestamps
          start = time unless start
          time -= start
          time /= beats_per_second

          case message.type
            when :note_on
              note_ons[message.pitch] = [message,time]

            when :note_off
              if note_ons.has_key? message.pitch
                note_on, start_time = note_ons[message.pitch]
                duration = time - start_time
                note = Note.from_midi note_on.pitch, note_on.velocity, duration
                timeline.add time,note
              end

            else timeline.add time,message
          end
        end

        timeline.quantize! options[:quantize] if options.key? :quantize
        timeline.shift_to! options[:shift_to] if options.key? :shift_to

        timeline
      end

    end
  end
end

