require 'midilib'

module MTK
  module IO

    # MIDI file I/O: reads MIDI files into {Events::Timeline}s and writes {Events::Timeline}s to MIDI files.
    # @note This class is optional and only available if you require 'mtk/midi/file'.
    #       It depends on the 'midilib' gem.
    class MIDIFile
      def initialize file
        if file.respond_to? :path
          @file = file.path
        else
          @file = file.to_s
        end
      end

      # Read a MIDI file into an Array of {Events::Timeline}s
      #
      # @return [Timeline]
      #
      def to_timelines
        timelines = []

        ::File.open(@file, 'rb') do |f|
          sequence = ::MIDI::Sequence.new
          sequence.read(f)
          pulses_per_beat = sequence.ppqn.to_f
          track_idx = -1

          sequence.each do |track|
            track_idx += 1
            timeline =  MTK::Events::Timeline.new
            note_ons = {}
            #puts "TRACK #{track_idx}"

            track.each do |event|
              #puts "#{event.class}: #{event}   @#{event.time_from_start}"
              time = (event.time_from_start)/pulses_per_beat

              case event
                when ::MIDI::NoteOn
                  note_ons[event.note] = [time,event]

                when ::MIDI::NoteOff
                  on_time,on_event = note_ons.delete(event.note)
                  if on_event
                    duration = time - on_time
                    note = MTK::Events::Note.from_midi(event.note, on_event.velocity, duration, event.channel)
                    timeline.add on_time, note
                  end

                when ::MIDI::Controller, ::MIDI::PolyPressure, ::MIDI::ChannelPressure, ::MIDI::PitchBend, ::MIDI::ProgramChange
                  timeline.add time, MTK::Events::Parameter.from_midi(*event.data_as_bytes)

                when ::MIDI::Tempo
                  # Not sure if event.tempo needs to be converted? TODO: test!
                  timeline.add time, MTK::Events::Parameter.new(:tempo, :value => event.tempo)
              end
            end
            timelines << timeline
          end
        end
        timelines
      end

      def write(anything)
        case anything
          when  MTK::Events::Timeline then write_timeline(anything)
          when Enumerable then write_timelines(anything)
          else raise "#{self.class}#write doesn't understand #{anything.class}"
        end
      end

      def write_timelines(timelines, parent_sequence=nil)
        sequence = parent_sequence || ::MIDI::Sequence.new
        timelines.each{|timeline| write_timeline(timeline, sequence) }
        write_to_disk sequence unless parent_sequence
      end

      # Write the Timeline as a MIDI file
      #
      # @param timeline [Timeline]
      def write_timeline(timeline, parent_sequence=nil)
        sequence = parent_sequence || ::MIDI::Sequence.new
        clock_rate = sequence.ppqn
        track = add_track sequence

        timeline.each do |time,events|
          time *= clock_rate

          events.each do |event|
            next if event.rest?

            channel = (event.channel || 1) - 1 # midilib seems to count channels from 0, hence the -1

            case event.type
              when :note
                pitch, velocity = event.midi_pitch, event.velocity
                add_event track, time => note_on(channel, pitch, velocity)
                duration = event.duration_in_pulses(clock_rate)
                add_event track, time+duration => note_off(channel, pitch, velocity)

              when :control
                add_event track, time => cc(channel, event.number, event.midi_value)

              when :pressure
                if event.number
                  add_event track, time => poly_pressure(channel, event.number, event.midi_value)
                else
                  add_event track, time => channel_pressure(channel, event.midi_value)
                end

              when :bend
                add_event track, time => pitch_bend(channel, event.midi_value)

              when :program
                add_event track, time => program(channel, event.midi_value)

              when :tempo
                add_event track, time => tempo(event.value)
            end
          end
        end
        track.recalc_delta_from_times

        write_to_disk sequence unless parent_sequence
      end


      ########################
      private

      def write_to_disk(sequence)
        puts "Writing file #{@file}" unless $__RUNNING_RSPEC_TESTS__
        ::File.open(@file, 'wb') { |f| sequence.write f }
      end

      def print_midi sequence
        sequence.each do |track|
          puts "\n*** track \"#{track.name}\""
          puts "#{track.events.length} events"
          track.each do |event|
            puts "#{event.to_s} (#{event.time_from_start})"
          end
        end
      end

      # Set tempo in terms of Quarter Notes per Minute (aka BPM)
      def tempo(bpm)
        ms_per_quarter_note = ::MIDI::Tempo.bpm_to_mpq(bpm)
        ::MIDI::Tempo.new(ms_per_quarter_note)
      end

      def program(channel, program_number)
        ::MIDI::ProgramChange.new(channel, program_number)
      end

      def note_on(channel, pitch, velocity)
        ::MIDI::NoteOn.new(channel, pitch.to_i, velocity)
      end

      def note_off(channel, pitch, velocity)
        ::MIDI::NoteOff.new(channel, pitch.to_i, velocity)
      end

      def cc(channel, controller, value)
        ::MIDI::Controller.new(channel, controller, value)
      end

      def poly_pressure(channel, pitch, value)
        ::MIDI::PolyPressure(channel, pitch.to_i, value)
      end

      def channel_pressure(channel, value)
        ::MIDI::ChannelPressure(channel, value)
      end

      def pitch_bend(channel, value)
        ::MIDI::PitchBend.new(channel, value)
      end

      def add_track sequence, opts={}
        track = ::MIDI::Track.new(sequence)
        track_name = opts[:name]
        track.name = track_name if track_name
        sequence.tracks << track
        sequence.format = if sequence.tracks.length > 1 then 1 else 0 end
        track
      end

      def add_event track, event_hash
        for time, event in event_hash
          event.time_from_start = time.round # MIDI file event times must be in whole number pulses (typically 480 or 960 per quarter note)
          track.events << event
          event
        end
      end

    end
  end

  # Shortcut for MTK::IO::MIDIFile.new
  # @note Only available if you require 'mtk/midi/file'
  def MIDIFile(f)
    ::MTK::IO::MIDIFile.new(f)
  end
  module_function :MIDIFile

end


####################################################################################
# MONKEY PATCHING to prevent blank instrument name meta events from being generated
# This can be removed if my pull request https://github.com/jimm/midilib/pull/5
# is merged into midilib and a new gem is released with these changes.

module MIDI
  module IO
    class SeqWriter
      alias original_write_instrument write_instrument
      def write_instrument(instrument)
        original_write_instrument(instrument) unless instrument.nil?
      end

      # Also monkey patching write_header to support alternate MIDI file formats
      def write_header
        @io.print 'MThd'
        write32(6)
        write16(@seq.format || 1)
        write16(@seq.tracks.length)
        write16(@seq.ppqn)
      end
    end
  end
end
