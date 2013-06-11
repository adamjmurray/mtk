require 'mtk/midi/output'

module MTK
  module IO

    # Optional class for loading the preferred platform-specific implementation of an output,
    # and methods to assist with selecting an output.
    class OutputSelector

      class << self

        def output
          MTK::MIDI::Output
        end

        # Look for an output by name using case insensitive matching,
        # treating underscore like either an underscore or whitespace
        def search output_name_pattern
          output.find_by_name(/#{output_name_pattern.to_s.sub '_','(_|\\s+)'}/i)
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
              return output.open(device) if device
            rescue
              if $DEBUG
                puts $!
                puts $!.backtrace
              end
              # keep looping
            end
            print "Invalid input. Enter a number listed above: "
          end
        end


        def ensure_output name=nil
          output = nil
          if name
            output = search name
            puts "Output '#{name}' not found." unless output
          end
          output || prompt_for_output
        end

      end

    end
  end
end
