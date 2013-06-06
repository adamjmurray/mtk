require 'unimidi'
require 'ostruct'

module MTK
  module MIDI

    # Provides realtime MIDI input for MRI/YARV Ruby via the unimidi gem.
    # @note This class is optional and only available if you require 'mtk/midi/unimidi_input'.
    #       It depends on the 'unimidi' gem.
    class UniMIDIInput < Input

      public_class_method :new

      def self.devices
        @devices ||= ::UniMIDI::Input.all.reject{|d| d.name.strip.empty? }
      end

      def self.devices_by_name
        @devices_by_name ||= devices.each_with_object( Hash.new ){|device,hash| hash[device.name] = device }
      end


      attr_reader :device, :recording, :thread

      def initialize(input_device, options={})
        super
        @open_time = Time.now.to_f
      end

      def record(options={})
        @recording = [] unless options[:append] and @recording
        monitor = options[:monitor]

        stop
        @thread = Thread.new do
          @start_time = Time.now.to_f
          loop do
            @device.gets.each do |data|
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
        return nil if not @recording

        bpm = options.fetch :bmp, 120
        beats_per_second = bpm.to_f/60
        timeline = Timeline.new
        note_ons = {}
        start = nil

        @recording.each do |message, time|
          start ||= time
          time -= start
          time /= beats_per_second

          if message.is_a? MTK::Events::Event
            timeline.add time,message
          else
            case message.type
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

      def record_raw_data raw
        status, data1, data2 = *raw[:data] # the 3 bytes of raw message data
        message = (
          case status & 0xF0
            when 0x80 then OpenStruct.new({:type => :note_off, :pitch => data1, :velocity => data2})
            when 0x90 then OpenStruct.new({:type => :note_on,  :pitch => data1, :velocity => data2})
            else MTK::Events::Parameter.from_midi(status,data1,data2)
          end
        )
        time = raw[:timestamp]/1000 - (@start_time - @open_time)
        @recording << [message, time]
      end

    end
  end
end

