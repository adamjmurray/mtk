(Work in progress)

Core Concepts
-------------

### Core data types

These model the basic properties of musical events:
* pitch_class (MTK class)
* pitch (MTK class)
* intensity (Numeric)
* duration (Numeric)

Like Numeric types, PitchClass and Pitch are immutable. This helps avoid confusing bugs.
Mostly you don't need to worry about this. Just remember when you call methods that change the value, like #invert,
it does not change the value in-place. For example:

     p = PitchClass[G]
     p = p.invert(E)  # because p.invert(E) does not change p

For efficiency and convenience, intensity and duration are modeled using Ruby's Numeric types (Fixnum, Float, etc).

Intensity is intended to range from 0.0 (minimum intensity) to 1.0 (maximum intensity).

A Duration of 1 is one beat (usually a quarter note, depending on the meter). By convention, negative durations
indicate a rest that lasts for the absolute value duration.


<br/>
### Events

Events group together the core data types together to represent a musical event, like a single Note.
Events can be converted to and from MIDI.

* event
* note


<br/>
### Core collections

A collection of timed events, such as a melody, a riff, or one track of an entire song.

* timeline


<br/>
### Patterns

Structured collections of core data types and other patterns. Used to generate musical material.

* cycle
* palindrome
* choice (randomly select from weghted distribution)
* line (linear interpolation between 2 points)
* function (dynamically generate elements with a lambda)

Future?
* curve (exponential/curved interpolation between points)
* permutation (cycle that permutes itself each cycle period)
* markov chain
* graph
* petri net (special type of graph??)
* custom (just implement enumerator pattern?)


<br/>
### Sequencers

Convert patterns into timelines



