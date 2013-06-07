require 'unimidi'

module MTK
  module MIDI

    # Provides realtime MIDI output for "standard" Ruby (MRI) via the unimidi and gamelan gems.
    # @note This class is optional and only available if you require 'mtk/midi/unimidi_output'.
    #       It depends on the 'unimidi' and 'gamelan' gems.
    class UniMIDIOutput < Output

      public_class_method :new

      def self.devices
        @devices ||= ::UniMIDI::Output.all.reject{|d| d.name.strip.empty? }
      end

      def self.devices_by_name
        @devices_by_name ||= devices.each_with_object( Hash.new ){|device,hash| hash[device.name] = device }
      end


      ######################
      protected

      # (see Output#note_on)
      def note_on(pitch, velocity, channel)
        @device.puts(0x90|channel, pitch, velocity)
      end

      # (see Output#note_off)
      def note_off(pitch, velocity, channel)
        @device.puts(0x80|channel, pitch, velocity)
      end

      # (see Output#control)
      def control(number, midi_value, channel)
        @device.puts(0xB0|channel, number, midi_value)
      end

      # (see Output#channel_pressure)
      def channel_pressure(midi_value, channel)
        @device.puts(0xD0|channel, midi_value, 0)
      end

      # (see Output#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        @device.puts(0xA0|channel, pitch, midi_value)
      end

      # (see Output#bend)
      def bend(midi_value, channel)
        @device.puts(0xE0|channel, midi_value & 127, (midi_value >> 7) & 127)
      end

      # (see Output#program)
      def program(number, channel)
        @device.puts(0xC0|channel, number, 0)
      end

    end
  end
end


#####################################################################
# MONKEY PATCHING for https://github.com/arirusso/ffi-coremidi/pull/2
# This can be removed once that pull request is released.

# @private
module CoreMIDI
  class Device
    def initialize(id, device_pointer, options = {})
      include_if_offline = options[:include_offline] || false
      @id = id
      @resource = device_pointer
      @entities = []

      prop = Map::CF.CFStringCreateWithCString( nil, "name", 0 )
      begin
        name_ptr = FFI::MemoryPointer.new(:pointer)
        Map::MIDIObjectGetStringProperty(@resource, prop, name_ptr)
        name = name_ptr.read_pointer
        len = Map::CF.CFStringGetMaximumSizeForEncoding(Map::CF.CFStringGetLength(name), :kCFStringEncodingUTF8)
        bytes = FFI::MemoryPointer.new(len + 1)
        raise RuntimeError.new("CFStringGetCString") unless Map::CF.CFStringGetCString(name, bytes, len, :kCFStringEncodingUTF8)
        @name = bytes.read_string
      ensure
        Map::CF.CFRelease(name) unless name.nil? || name.null?
        Map::CF.CFRelease(prop) unless prop.null?
      end
      populate_entities(:include_offline => include_if_offline)
    end

  end

  module Map
    module CF

      extend FFI::Library
      ffi_lib '/System/Library/Frameworks/CoreFoundation.framework/Versions/Current/CoreFoundation'

      typedef :pointer, :CFStringRef
      typedef :long, :CFIndex
      enum :CFStringEncoding, [ :kCFStringEncodingUTF8, 0x08000100 ]

      # CFString* CFStringCreateWithCString( ?, CString, encoding)
      attach_function :CFStringCreateWithCString, [:pointer, :string, :int], :pointer
      # CString* CFStringGetCStringPtr(CFString*, encoding)
      attach_function :CFStringGetCStringPtr, [:pointer, :int], :pointer

      attach_function :CFStringGetLength, [ :CFStringRef ], :CFIndex

      attach_function :CFStringGetMaximumSizeForEncoding, [ :CFIndex, :CFStringEncoding ], :long

      attach_function :CFStringGetCString, [ :CFStringRef, :pointer, :CFIndex, :CFStringEncoding ], :bool

      attach_function :CFRelease, [ :pointer ], :void

    end
  end
end