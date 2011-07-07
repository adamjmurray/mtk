Just starting to jot down some notes... this document is not ready yet.

Core Concepts
-------------

### Core data types

* pitch_class (MTK class)
* pitch (MTK class)
* intensity (Numeric)
* duration (Numeric)

PitchClass and Pitch are immutable.


### Events

* event
* note


### Core collections

* timeline


### Patterns

Structured collections of core data types and other patterns

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


### Sequencers

Convert patterns into timelines


### Generators

Generate patterns (or sequencers or timelines?)

