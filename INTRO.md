(Work in progress)

Core Concepts
-------------

### Core data types

These model the basic properties of musical events:
* PitchClass
* Pitch
* Duration
* Intensity

These types are all immutable. This helps avoid confusing bugs.
Mostly you don't need to worry about this. Just remember when you call methods that change the value, like #invert,
it does not change the value in-place. For example:

     p = PitchClass[G]
     p = p.invert(E)  # because p.invert(E) does not change p

Intensity values are intended to range from 0.0 (minimum intensity) to 1.0 (maximum intensity).

A Duration of 1 is one beat (usually a quarter note, depending on the meter, but note the quarter note value in this
library is 1 beat, so adjust accordingly for non-standard meters). By convention, negative durations
indicate a rest that lasts for the absolute value duration.

Additionally there is a core type Interval to model intervals between pitches and pitch classes.


<br/>
### Events

Events group together the core data types together to represent a musical event, like a single Note.
Events can be converted to and from MIDI.

* Event
* Note
* Parameter

Paramter represents any non-note event like a MIDI CC, pitch bend, aftertouch (pressure), etc.

Events with a negative duration are considered a rest. There is also a dedicated rest class so you
don't have to specifiy unnecessary properties like pitch for a rest.

Events are organized in time via the Timeline


<br/>
### Creating Core data types and Events

The Core types as well as Note events have "convenience constructors" under the top-level MTK module.

You can construct objects from almost any arguments by using the methods such as MTK.Pitch() and MTK.Note().
These methods do their best to guess what you want from the arguments and even handle out-of-order arguments
in most cases. See the unit tests for ideas...


<br/>
### Collections

The collection classes need some work... The interface is likely to change so it's best to not rely on them too much
right now.


<br/>
### Patterns

Structured collections of core data types and other patterns. Used to generate musical material.

* cycle
* palindrome
* choice (randomly select from weghted distribution)
* line (linear interpolation between 2 points)
* function (dynamically generate elements with a lambda)

To be added in the Future?
* curve (exponential/curved interpolation between points)
* permutation (cycle that permutes itself each cycle period)
* markov chain
* graph
* petri net (special type of graph??)
* custom (just implement enumerator pattern?)


<br/>
### Sequencers

Convert patterns into event Timelines

The sequencer classes differ in terms of how they determine how much time should occur between one event and the next.
So far the options are:
* LegatoSequencer - the end of each event is the start of the next event
* RhythmSequencer - requires a special rhythm-type patter to determine the inter-event time intervals
* StepSequencer - uses a constant amount of time between all events. In other words, works like a drum sequencer/


<br/>
### Syntax

Basic Tenants

* Minimal syntax: less typing means more music!
* Case-sensitive to allow for more to be expressed in fewer characters.
* Pitch and duration are the most important properties

Because pitch class and duration are such important properties, and we want to minimize typing, we represent these with 1 letter.

**Diatonic Pitch Class: C D E F G A B**

**Chromatic Pitch Class (Sharp/Flat): C/B# C#/Db D D#/Eb E/Fb E#/F F#/Gb G G#/Ab A A#/Bb B/Cb**

Double-sharps (C##) and double-flats (Dbb) are also allowed.

**Pitch (Pitch Class + Octave Number): C4 Db5 C-1 G9**

C-1 (that's octave number: negative 1) is the lowest note. G9 is the highest.
Note: The MTK syntax expects C-1 as you'd expect, but the corresponding constant in Ruby is C_1 to ensure valid Ruby syntax.

**Duration: w h q e s r x (that's: whole note, half, quarter, eighth, sixteenth, thirty-second, sixty-fourth)**

In the MTK syntax, durations can be suffixed with "t" or "." for triplets and dotted-notes
(mathematically that multiplies the dureation by 2/3 or 1.5).

Why "r", and "x"? We're trying to keep these one letter.
"t" is used for triplets, so the thirty-second note became "r".
"s" is used by sixteenth notes, so the sixty-fourth note became "x".
Hopefully this abnormal naming won't cause problems since those duration values are fairly uncommon.


**Intensity: ppp pp p mp mf f ff fff**


TODO: keep documenting this...
TODO: explanation of intervals


Summary of single-letter assignments:
```
A -> pitch class A
B -> pitch class B
b -> flat modifier on pitch class
D -> pitch class c
D -> pitch class d
E -> pitch class e
e -> eighth note duration
F -> pitch class f
f -> forte intensity

h -> half note duration
i -> minor tonic chord (PLANNED, not implemented yet)

p -> piano intensity
q -> quarter note duration
r -> thirty-second note duration
s -> sixteenth note duration
t -> triplet modifier on durations

v -> minor dominant chord (PLANNED, not implemented yet)
w -> whole note duration
x -> sixty-fourth note duration
```
