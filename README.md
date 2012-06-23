MTK
===

Music ToolKit for Ruby
----------------------

Classes for modeling music with a focus on simplicity. Support for reading/writing MIDI files and realtime MIDI.



Getting Started
---------------

    gem install mtk

or download the source from here and add mtk/lib to your $LOAD_PATH. Then...

    require 'mtk'

Some examples are available in the examples folder (more coming soon).
The specs provide a lot of details of usage...



Goals
-----

* Build musical generators to assist with composing music
* Re-implement Cosy (http://compusition.com/web/software/cosy) using these models as the "backend"



Status
------

Alpha phase, API subject to change. Feedback welcome!



Requirements
------------

### Ruby Version

Ruby 1.9+ or JRuby 1.6+


### Dependencies

MTK's core features should not depend on anything outside of the Ruby standard library.


MTK's optional features typically require gems. Currently the following gems are required:

* MIDI file I/O requires the __midilib__ gem

* realtime MIDI I/O with (MRI/YARV) Ruby requires the __unimidi__ and __gamelan__ gems

* realtime MIDI I/O with JRuby require the __jsound__ and __gamelan__ gems

* The custom MTK syntax (work in progress) requires the __citrus__ gem


Development requires the gems for optional features, plus the following:

* rake
* rspec (tests)
* yard (docs)

You shouldn't need to worry about the dependencies too much. A Gemfile is provided to sort this out for you:

    gem install bundler
    bundle install

[rvm](https://rvm.beginrescueend.com/) is recommended for cross version testing (see Development Notes below)



Documentation
-------------

Gem: http://rdoc.info/gems/mtk/0.0.2/frames

Latest for source: http://rubydoc.info/github/adamjmurray/mtk/master/frames



Development Notes
-----------------

### Run Tests ###

Test with current version of Ruby:

     rake spec

Test with all supported versions of Ruby (requires [rvm](https://rvm.beginrescueend.com/), YARV 1.9.3, and JRuby 1.6.7):

     rake spec:all

The spec:all test must pass for a pull request to be accepted or for a release of the mtk gem.


### Generate Docs ###

     yard
     open doc/frames.html

or, to automatically refresh the documentation as you work:

      yard server -r
      open http://localhost:8808


### Project Roadmap ###

https://www.pivotaltracker.com/projects/295419



Changelog
---------

* Upcoming...
    - Added realtime MIDI output for (MRI/YARV) Ruby

* July 8, 2011: version 0.0.2
    - Added a Sequencer module to build Timelines out of Patterns
    - Overhauled Pattern module: removed type-specific patterns, and added the Palindrome, Lines, and Function patterns
    - Patterns can now be nested (they can contain other Patterns)
    - Patterns can now be typed, to distinguish Numeric Patterns as :pitch (i.e. intervals), :intensity, :duration, or :rhythm patterns
    - Removed auto-sorting behavior from PitchClassSet to support 12-tone rows and atonal composition techniques
    - Added #quantize and #shift features to Timeline
    - Got rid of Chord class, model Chords with PitchSets or Arrays of Notes instead
    - Added support for realtime MIDI I/O with JSound (JRuby only)
    - various cleanup and reorganization

* June 8, 2011: version 0.0.1
    - First gem release.