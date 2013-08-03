module MTK
  module IO

    # Common behavior for realtime MIDI input.
    #
    class MIDIInput

      class << self

        def inherited(subclass)
          available_input_types << subclass
        end

        def available_input_types
          @available_input_types ||= []
        end

        def input_types_by_device
          @input_types_by_device ||= (
          available_input_types.each_with_object( Hash.new ) do |input_type,hash|
            input_type.devices.each{|device| hash[device] = input_type }
          end
          )
        end

        # All available input devices.
        def devices
          @devices ||= available_input_types.map{|input_type| input_type.devices }.flatten
        end

        # Maps input device names to the input device.
        def devices_by_name
          @devices_by_name ||= (
          available_input_types.each_with_object( Hash.new ) do |input_type,hash|
            hash.merge!( input_type.devices_by_name )
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
          input_type = input_types_by_device[device]
          input_type.new(device) if input_type
        end
      end


      def initialize(input_device, options={})
        @device = input_device
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

      def record
      end

      def stop
      end

      def to_timeline
        MTK::Events::Timeline.new
      end

    end
  end
end


unless $__RUNNING_RSPEC_TESTS__ # I can't get this working on Travis-CI, problem installing native dependencies
  if RUBY_PLATFORM == 'java'
    require 'mtk/io/jsound_input'
  else
    require 'mtk/io/unimidi_input'
  end
end