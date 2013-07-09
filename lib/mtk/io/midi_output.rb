require 'rbconfig'
require 'gamelan'

module MTK
  module IO

    # Provides a scheduler and common behavior for realtime MIDI output, using the gamelan gem for scheduling.
    #
    # @abstract Subclasses must provide {.devices}, {.devices_by_name}, {#note_on}, {#note_off}, {#control}, {#channel_pressure}, {#poly_pressure}, {#bend}, and {#program} to implement a MIDI output.
    #
    class MIDIOutput

      class << self

        def inherited(subclass)
          available_output_types << subclass
        end

        def available_output_types
          @available_output_types ||= []
        end

        def output_types_by_device
          @output_types_by_device ||= (
            available_output_types.each_with_object( Hash.new ) do |output_type,hash|
              output_type.devices.each{|device| hash[device] = output_type }
            end
          )
        end

        # All available output devices.
        def devices
          @devices ||= available_output_types.map{|output_type| output_type.devices }.flatten
        end

        # Maps output device names to the output device.
        def devices_by_name
          @devices_by_name ||= (
            available_output_types.each_with_object( Hash.new ) do |output_type,hash|
              hash.merge!( output_type.devices_by_name )
            end
          )
        end

        def find_by_name(name)
          if name.is_a? Regexp
            matching_name = devices_by_name.keys.find{|device_name| device_name =~ name }
            device = devices_by_name[matching_name]
          else
            device = devices_by_name[name.to_s]
          end
          open(device) if device
        end

        def open(device)
          output_type = output_types_by_device[device]
          output_type.new(device) if output_type
        end
      end


      def initialize(output_device, options={})
        @device = output_device
        @device.open
        @options = options
      end
      private_class_method :new


      ########################
      public

      # The underlying output device implementation wrapped by this class.
      # The device type depends on the platform.
      attr_reader :device

      def name
        @device.name
      end

      def play(anything, options={})
        timeline = case anything
          when MTK::Events::Timeline then anything
          when Hash then  MTK::Events::Timeline.from_h anything
          when Enumerable,MTK::Events::Event then  MTK::Events::Timeline.from_h(0 => anything)
          else raise "#{self.class}.play() doesn't understand #{anything} (#{anything.class})"
        end
        timeline = timeline.flatten

        scheduler_rate = options.fetch :scheduler_rate, 500 # default: 500 Hz
        trailing_buffer = options.fetch :trailing_buffer, 2 # default: continue playing for 2 beats after the end of the timeline
        in_background = options.fetch :background, false # default: don't run in background Thread
        bpm = options.fetch :bmp, 120 # default: 120 beats per minute

        @scheduler = Gamelan::Scheduler.new :tempo => bpm, :rate => scheduler_rate

        timeline.each do |time,events|
          events.each do |event|
            next if event.rest?

            channel = event.channel || 0

            case event.type
              when :note
                pitch = event.midi_pitch
                velocity = event.velocity
                duration = event.duration.to_f
                @scheduler.at(time) { note_on(pitch,velocity,channel) }
                @scheduler.at(time + duration) { note_off(pitch,velocity,channel) }

              when :control
                @scheduler.at(time) { control(event.number, event.midi_value, channel) }

              when :pressure
                if event.number
                  @scheduler.at(time) { poly_pressure(event.number, event.midi_value, channel) }
                else
                  @scheduler.at(time) { channel_pressure(event.midi_value, channel) }
                end

              when :bend
                @scheduler.at(time) { bend(event.midi_value, channel) }

              when :program
                @scheduler.at(time) { program(event.number, channel) }
            end
          end
        end

        end_time = timeline.times.last
        final_events = timeline[end_time]
        max_length = final_events.inject(0) {|max,event| len = event.length; max > len ? max : len } || 0
        end_time += max_length + trailing_buffer
        @scheduler.at(end_time) { @scheduler.stop }

        thread = @scheduler.run
        thread.join if not in_background
      end


      ########################
      protected

      # these all return stubbed data for testing purposes

      # Send a note on event to the MIDI output
      def note_on(midi_pitch, velocity, channel)
        [:note_on, midi_pitch, velocity, channel] # stubbed data for testing purposes
      end

      # Send a note off event to the MIDI output
      def note_off(midi_pitch, velocity, channel)
        [:note_off, midi_pitch, velocity, channel]
      end

      # Send a control change event to the MIDI output
      def control(number, midi_value, channel)
        [:control, number, midi_value, channel]
      end

      # Send a poly pressure event to the MIDI output.
      def poly_pressure(midi_pitch, midi_value, channel)
        [:poly_pressure, midi_pitch, midi_value, channel]
      end

      # Send a channel pressure event to the MIDI output.
      def channel_pressure(midi_value, channel)
        [:channel_pressure, midi_value, channel]
      end

      # Send a pitch bend event to the MIDI output.
      def bend(midi_value, channel)
        [:bend, midi_value, channel]
      end

      # Send a program change event to the MIDI output.
      def program(number, channel)
        [:program, number, channel]
      end

    end

  end
end


unless $__RUNNING_RSPEC_TESTS__ # I can't get this working on Travis-CI, problem installing native dependencies
  if RbConfig::CONFIG['host_os'] =~ /darwin/
    # We're running on OS X
    require 'mtk/io/dls_synth_output'
  end

  if RUBY_PLATFORM == 'java'
    require 'mtk/io/jsound_output'
  else
    require 'mtk/io/unimidi_output'
  end
end