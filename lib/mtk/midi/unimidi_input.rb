require 'rubygems'
require 'unimidi'
require 'ostruct'

module MTK
  module MIDI

    # Provides realtime MIDI input for MRI/YARV Ruby via the unimidi gem.
    # @note This class is optional and only available if you require 'mtk/midi/unimidi_input'.
    #       It depends on the 'unimidi' gem.
    class UniMIDIInput

      attr_reader :device, :recording, :thread

      def initialize(input, options={})
        if input.is_a? ::UniMIDI::CongruousApiInput
          @device = input
        else
          input = /#{input.to_s.sub '_','.*'}/i unless input.is_a? Regexp
          @device = ::UniMIDI::Input.all.find {|o| o.name =~ input }
        end
        @device.open
        @open_time = Time.now.to_f
      end

      def record(options={})
        @recording = [] unless options[:append] and @recording
        monitor = options[:monitor]

        stop
        @thread = Thread.new do
          @start_time = Time.now.to_f
          loop do
            for data in @device.gets
              puts data if monitor
              record_raw_data data
            end
            sleep 0.001
          end
        end

        time_limit = options[:time_limit]
        if time_limit
          puts "Blocking current thread for #{time_limit} seconds to record MIDI input."
          @thread.join(time_limit)
        end
      end

      def stop
        Thread.kill @thread if @thread
      end

      def to_timeline(options={})
        bpm = options.fetch :bmp, 120
        beats_per_second = bpm.to_f/60
        timeline = Timeline.new
        note_ons = {}
        start = nil

        for message,time in @recording
          start ||= time
          time -= start
          time /= beats_per_second

          case message.type
            when :note_on
              pitch = message.pitch
              note_ons[pitch] = [message,time]

            when :note_off
              pitch = message.pitch
              if note_ons.has_key? pitch
                note_on, start_time = note_ons[pitch]
                duration = time - start_time
                note = Note.from_midi pitch, note_on.velocity, duration
                timeline.add time,note
              end

            when :unknown # ignore

            else timeline.add time,message
          end
        end

        timeline.quantize! options[:quantize] if options.key? :quantize
        timeline.shift_to! options[:shift_to] if options.key? :shift_to

        timeline
      end


      #######################
      private

      def record_raw_data raw
        status, data1, data2 = *raw[:data] # the 3 bytes of raw message data
        message = OpenStruct.new({:channel => status & 0x0F}.merge(
          case status & 0xF0
            when 0x80 then {:type => :note_off, :pitch => data1, :velocity => data2}
            when 0x90 then {:type => :note_on,  :pitch => data1, :velocity => data2}
            when 0xA0 then {:type => :poly_pressure, :pitch => data1, :pressure => data2}
            when 0xB0 then {:type => :control_change,  :number => data1, :value => data2}
            when 0xC0 then {:type => :program_change,  :number => data1}
            when 0xD0 then {:type => :channel_pressure, :pressure => data1 } # no pitch means all notes on channel
            when 0xE0 then {:type => :pitch_bend, :value => (data1 + (data2 << 7)) }
            else {:type => :unknown, :raw => raw[:data]}
          end
        ))
        time = raw[:timestamp]/1000 - (@start_time - @open_time)
        @recording << [message, time]
      end

    end
  end
end
