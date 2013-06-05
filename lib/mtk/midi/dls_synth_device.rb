require 'ffi'

module MTK
  module MIDI

    # An output device for Apple's built-in "DLS" synthesizer on OS X
    class DLSSynthDevice

      module AudioToolbox
        extend FFI::Library
        ffi_lib '/System/Library/Frameworks/AudioToolbox.framework/Versions/Current/AudioToolbox'
        ffi_lib '/System/Library/Frameworks/AudioUnit.framework/Versions/Current/AudioUnit'

        class ComponentDescription < FFI::Struct
          layout :componentType, :int,
                 :componentSubType, :int,
                 :componentManufacturer, :int,
                 :componentFlags, :int,
                 :componentFlagsMask, :int
        end

        def self.to_bytes(s)
          bytes = 0
          s.each_byte do |byte|
            bytes <<= 8
            bytes += byte
          end
          return bytes
        end

        AUDIO_UNIT_MANUFACTURER_APPLE = to_bytes('appl')
        AUDIO_UNIT_TYPE_MUSIC_DEVICE = to_bytes('aumu')
        AUDIO_UNIT_SUBTYPE_DLS_SYNTH = to_bytes('dls ')
        AUDIO_UNIT_TYPE_OUTPUT = to_bytes('auou')
        AUDIO_UNIT_SUBTYPE_DEFAULT_OUTPUT = to_bytes('def ')

        # int NewAUGraph(void *)
        attach_function :NewAUGraph, [:pointer], :int

        # int AUGraphAddNode(void *, ComponentDescription *, void *)
        attach_function :AUGraphAddNode, [:pointer, :pointer, :pointer], :int

        # int AUGraphOpen(void *)
        attach_function :AUGraphOpen, [:pointer], :int

        # int AUGraphConnectNodeInput(void *, void *, int, void *, int)
        attach_function :AUGraphConnectNodeInput, [:pointer, :pointer, :int, :pointer, :int], :int

        # int AUGraphNodeInfo(void *, void *, ComponentDescription *, void *)
        attach_function :AUGraphNodeInfo, [:pointer, :pointer, :pointer, :pointer], :int

        # int AUGraphInitialize(void *)
        attach_function :AUGraphInitialize, [:pointer], :int

        # int AUGraphStart(void *)
        attach_function :AUGraphStart, [:pointer], :int

        # int AUGraphStop(void *)
        attach_function :AUGraphStop, [:pointer], :int

        # int DisposeAUGraph(void *)
        attach_function :DisposeAUGraph, [:pointer], :int

        # void * CAShow(void *)
        attach_function :CAShow, [:pointer], :void

        # void * MusicDeviceMIDIEvent(void *, int, int, int, int)
        attach_function :MusicDeviceMIDIEvent, [:pointer, :int, :int, :int, :int], :void

      end


      ##################################

      def name
        'Apple DLS Synthesizer'
      end


      def require_noerr(action_description, &block)
        if block.call != 0
          fail "Failed to #{action_description}"
        end
      end


      def open
        synth_pointer = FFI::MemoryPointer.new(:pointer)
        graph_pointer = FFI::MemoryPointer.new(:pointer)
        synth_node_pointer = FFI::MemoryPointer.new(:pointer)
        out_node_pointer = FFI::MemoryPointer.new(:pointer)

        cd = AudioToolbox::ComponentDescription.new
        cd[:componentManufacturer] = AudioToolbox::AUDIO_UNIT_MANUFACTURER_APPLE
        cd[:componentFlags] = 0
        cd[:componentFlagsMask] = 0

        require_noerr('create AUGraph') { AudioToolbox.NewAUGraph(graph_pointer) }
        @graph = graph_pointer.get_pointer(0)

        cd[:componentType] = AudioToolbox::AUDIO_UNIT_TYPE_MUSIC_DEVICE
        cd[:componentSubType] = AudioToolbox::AUDIO_UNIT_SUBTYPE_DLS_SYNTH
        require_noerr('add synthNode') { AudioToolbox.AUGraphAddNode(@graph, cd, synth_node_pointer) }
        synth_node = synth_node_pointer.get_pointer(0)

        cd[:componentType] = AudioToolbox::AUDIO_UNIT_TYPE_OUTPUT
        cd[:componentSubType] = AudioToolbox::AUDIO_UNIT_SUBTYPE_DEFAULT_OUTPUT
        require_noerr('add outNode') { AudioToolbox.AUGraphAddNode(@graph, cd, out_node_pointer) }
        out_node = out_node_pointer.get_pointer(0)

        require_noerr('open graph') { AudioToolbox.AUGraphOpen(@graph) }

        require_noerr('connect synth to out') { AudioToolbox.AUGraphConnectNodeInput(@graph, synth_node, 0, out_node, 0) }

        require_noerr('graph info') { AudioToolbox.AUGraphNodeInfo(@graph, synth_node, nil, synth_pointer) }
        @synth = synth_pointer.get_pointer(0)

        require_noerr('init graph') { AudioToolbox.AUGraphInitialize(@graph) }
        require_noerr('start graph') { AudioToolbox.AUGraphStart(@graph) }

        # AudioToolbox.CAShow(@graph) # for debugging
      end


      def message(*args)
        arg0 = args[0] || 0
        arg1 = args[1] || 0
        arg2 = args[2] || 0
        AudioToolbox.MusicDeviceMIDIEvent(@synth, arg0, arg1, arg2, 0)
      end


      def close
        if @graph
          AudioToolbox.AUGraphStop(@graph)
          AudioToolbox.DisposeAUGraph(@graph)
        end
      end
    end

  end
end


