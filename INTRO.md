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


<br/>
### Syntax

Basic Tenants

* Minimal syntax: less typing means more music!
* Be case-insensitive to avoid typos caused by lower vs upper case (there's one notable exception for intervals: m2 vs M2)
* pitch and duration are the most important properties
* pitch is more important than rhythm

Because pitch class and duration are such important properties, and we want to minimize typing, we represent these with 1 letter.

**Diatonic Pitch Class: c d e f g a b**

**Chromatic Pitch Class (Sharp/Flat): c c# db d d# eb e e# fb f f# gb g g# ab a a# bb b b#**

Double-sharps (c##) and double-flats (dbb) are also allowed. You may prefer Bb to bb, etc

**Pitch (Pitch Class + Octave Number): c4 db5 c-1 g9**

c-1 (that's octave number: negative 1) is the lowest note. g9 is the highest.

**Duration: w h q i s r x (that's: whole note, half, quarter, eighth, sixteenth, thirty-second, sixty-fourth)**

Why "i", "r", and "x"? We're trying to keep these one letter. 'e', 'r', and 's' were already used,
so we just move along the letters of the word until we find an unused letter.

For intensity, we'll try to use standard music notation, but 'f' conflicts, so we handle this the same way we did with durations:

**Intensity: ppp pp p mp mf o ff fff**

(You may find it helpful to think "loud" for "o")


TODO: keep documenting this...


Summary of single-letter assignments:
```
a -> pitch class a
b -> pitch class b, flat modifier on pitch class
c -> pitch class c
d -> pitch class d
e -> pitch class e
f -> pitch class f

h -> half note duration
i -> eighth note duration

o -> forte intensity
p -> piano intensity
q -> quarter note duration
r -> thirty-second note duration
s -> sixteenth note duration
t -> triplet modifier on durations

w -> whole note duration
x -> sixty-fourth note duration
```
