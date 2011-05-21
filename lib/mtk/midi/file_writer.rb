require 'rubygems'
require 'midilib'
MIDILIB = MIDI unless defined? MIDILIB # helps distinguish MTK::MIDI from midilib's MIDI, and avoids a JRuby-1.5 bug with module name collision

module MTK
  module MIDI

    # Writes a {Timeline} to a MIDI file.
    #
    # Requires the midilib gem (https://github.com/jimm/midilib)
    #
    class FileWriter

      # Creates a new FileWriter and yields it to the provided block.
      #
      # @example FileWriter.open('output.mid') {|f| f.write timeline }
      # @yield [FileWriter]
      # @see #initialize
      def self.open(file, options={})
        yield new(file, options)
      end

      # @param filepath [String, #path] path of the file to be written
      # @param options [Hash] optional settings (padding, tempo, program)
      # @see open
      def initialize(filepath, options={})
        @file = filepath
        @file = @file.path if @file.respond_to? :path
      end

      # Write the Timeline as a MIDI file
      #
      # @param [Timeline]
      def write(timeline)
        @sequence = MIDILIB::Sequence.new
        @track = track()
        @channel = 1
        @time = 0

        timeline.each do |time, event|
          @time = time*pulses_per_beat
          case event
            when Note
              pitch = event.pitch
              velocity = event.velocity
              duration = event.duration_in_pulses pulses_per_beat
              event note_on(pitch, velocity)
              @time += duration
              event note_off(pitch, velocity)

            when Chord
              velocity = event.velocity
              duration = event.duration_in_pulses pulses_per_beat
              start_time = @time
              for pitch in event.pitches
                @time = start_time
                event note_on(pitch, velocity)
                @time += duration
                event note_off(pitch, velocity)
              end

          end
        end
        @track.recalc_delta_from_times

        print_midi if $DEBUG
        File.open(@file, 'wb') {|f| @sequence.write f }
      end

      ########################
      private

      def pulses_per_beat
        @sequence.ppqn
      end

      def print_midi
        @sequence.each do |track|
          puts "\n*** track \"#{track.name}\""
          puts "#{track.events.length} events"
          track.each do |event|
            puts "#{event.to_s} (#{event.time_from_start})"
          end
        end
      end

      # Set tempo in terms of Quarter Notes per Minute (aka BPM)
      def tempo(bpm)
        @tempo = bpm
        ms_per_quarter_note = MIDILIB::Tempo.bpm_to_mpq(bpm)
        MIDILIB::Tempo.new(ms_per_quarter_note)
      end

      def program(program_number)
        MIDILIB::ProgramChange.new(@channel, program_number)
      end

      def note_on(pitch, velocity)
        MIDILIB::NoteOn.new(@channel, pitch.to_i, velocity.to_i)
      end

      def note_off(pitch, velocity)
        MIDILIB::NoteOff.new(@channel, pitch.to_i, velocity.to_i)
      end

      def cc(controller, value)
        MIDILIB::Controller.new(@channel, controller.to_i, value.to_i)
      end

      def pitch_bend(value)
        MIDILIB::PitchBend.new(@channel, value)
      end

      def track(name=nil)
        track = MIDILIB::Track.new(@sequence)
        track.name = name if name
        @sequence.tracks << track
        track
      end

      def event e, track=@track
        e.time_from_start = @time
        track.events << e
        e
      end

    end

  end
end
