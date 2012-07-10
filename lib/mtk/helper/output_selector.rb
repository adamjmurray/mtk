if RUBY_PLATFORM == 'java'
  require 'mtk/midi/jsound_output'
else
  require 'mtk/midi/unimidi_output'
end

module MTK
  module Helper

    # Optional class for loading the preferred platform-specific implementation of an output,
    # and methods to assist with selecting an output.
    class OutputSelector

      class << self

        def output
          @output ||= if RUBY_PLATFORM == 'java'
            MTK::MIDI::JSoundOutput
          else
            MTK::MIDI::UniMIDIOutput
          end
        end

        # Look for an output by name using case insensitive matching,
        # treating underscore like either an underscore or whitespace
        def search output_name_pattern
          output.find_by_name /#{output_name_pattern.to_s.sub '_','(_|\\s+)'}/i
        end

        # Command line interface to list output choices and select an output.
        def prompt_for_output
          devices_by_name = output.devices_by_name
          names_by_number = {}

          puts "Available MIDI outputs:"
          devices_by_name.keys.each_with_index do |name,index|
            number = index+1
            names_by_number[number] = name
            puts " #{number} => #{name}"
          end

          print "Enter the number of the output to test: "
          device = nil
          loop do
            begin
              number = STDIN.gets.to_i
              name = names_by_number[number]
              device = devices_by_name[name]
              return output.new device if device
            rescue
              # keep looping
            end
            print "Invalid input. Enter a number listed above: "
          end
        end


        def ensure_output name=nil
          output = nil
          if name
            output = MTK::Helper::OutputSelector.search name
            puts "Output '#{name}' not found." unless output
          end
          output || MTK::Helper::OutputSelector.prompt_for_output
        end

      end

    end
  end
end
