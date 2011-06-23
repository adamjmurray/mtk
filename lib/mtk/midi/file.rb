require 'rubygems'
require 'midilib'

module MTK
  module MIDI

    class File
      def initialize file
        if file.respond_to? :path
          @file = file.path
        else
          @file = file.to_s
        end
      end

      # Read a MIDI file into an Array of {Timeline}s
      #
      # @param filepath [String, #path] path of the file to be written
      # @return [Timeline]
      #
      def to_timelines
        timelines = []

        ::File.open(@file, 'rb') do |f|
          sequence = ::MIDI::Sequence.new
          sequence.read(f)
          pulses_per_beat = sequence.ppqn.to_f
          track_idx = -1

          for track in sequence
            track_idx += 1
            timeline = Timeline.new
            note_ons = {}
            #puts "TRACK #{track_idx}"

            for event in track
              #puts "#{event.class}: #{event}   @#{event.time_from_start}"
              case event
                when ::MIDI::NoteOn
                  note_ons[event.note] = event

                when ::MIDI::NoteOff
                  if on_event = note_ons.delete(event.note)
                    time = (on_event.time_from_start)/pulses_per_beat
                    duration = (event.time_from_start - on_event.time_from_start)/pulses_per_beat
                    note = Note.from_midi event.note, on_event.velocity, duration
                    timeline.add time, note
                  end
              end
            end
            timelines << timeline
          end
        end
        timelines
      end

      def write(anything)
        case anything
          when Timeline then
            write_timeline(anything)
          when Array then
            write_timelines(anything)
          else
            raise "#{self.class}#write doesn't understand #{anything.class}"
        end
      end

      def write_timelines(timelines, parent_sequence=nil)
        sequence = parent_sequence || ::MIDI::Sequence.new
        for timeline in timelines
          write_timeline(timeline, sequence)
        end
        write_to_disk sequence unless parent_sequence
      end

      # Write the Timeline as a MIDI file
      #
      # @param [Timeline]
      def write_timeline(timeline, parent_sequence=nil)
        sequence = parent_sequence || ::MIDI::Sequence.new
        clock_rate = sequence.ppqn
        track = add_track sequence
        channel = 1

        for time,events in timeline
          for event in events
            next if event.rest?

            time *= clock_rate

            case event
              when Note
                pitch, velocity = event.pitch, event.velocity
                add_event track, time => note_on(channel, pitch, velocity)
                duration = event.duration_in_pulses(clock_rate)
                add_event track, time+duration => note_off(channel, pitch, velocity)

              when Chord
                velocity = event.velocity
                duration = event.duration_in_pulses(clock_rate)
                for pitch in event.pitches
                  pitch = pitch.to_i
                  add_event track, time => note_on(channel, pitch, velocity)
                  add_event track, time+duration => note_off(channel, pitch, velocity)
                end

            end
          end
        end
        track.recalc_delta_from_times

        write_to_disk sequence unless parent_sequence
      end


      ########################
      private

      def write_to_disk(sequence)
        ::File.open(@file, 'wb') { |f| sequence.write f }
      end

      def print_midi sequence
        for track in sequence
          puts "\n*** track \"#{track.name}\""
          puts "#{track.events.length} events"
          for event in track
            puts "#{event.to_s} (#{event.time_from_start})"
          end
        end
      end

      # Set tempo in terms of Quarter Notes per Minute (aka BPM)
      def tempo(bpm)
        ms_per_quarter_note = ::MIDI::Tempo.bpm_to_mpq(bpm)
        ::MIDI::Tempo.new(ms_per_quarter_note)
      end

      def program(program_number)
        ::MIDI::ProgramChange.new(channel, program_number)
      end

      def note_on(channel, pitch, velocity)
        ::MIDI::NoteOn.new(channel, pitch.to_i, velocity)
      end

      def note_off(channel, pitch, velocity)
        ::MIDI::NoteOff.new(channel, pitch.to_i, velocity)
      end

      def cc(channel, controller, value)
        ::MIDI::Controller.new(channel, controller.to_i, value.to_i)
      end

      def pitch_bend(channel, value)
        ::MIDI::PitchBend.new(channel, value)
      end

      def add_track sequence, opts={}
        track = ::MIDI::Track.new(sequence)
        track.name = opts.fetch :name, ''
        sequence.tracks << track
        track
      end

      def add_event track, event_hash
        for time, event in event_hash
          event.time_from_start = time
          track.events << event
          event
        end
      end

    end
  end

  # Shortcut for MTK::MIDI::File.new
  # @note Only available if you require 'mtk/midi/file'
  def MIDI_File(f)
    MIDI::File.new(f)
  end
  module_function :MIDI_File

end

