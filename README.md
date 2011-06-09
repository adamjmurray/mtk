# MTK
## Music ToolKit for Ruby

Classes for modeling music with a focus on simplicity. Support for reading/writing MIDI files (and soon, realtime MIDI).


# Getting Started

    gem install mtk

or download the source from here and add mtk/lib to your $LOAD_PATH. Then...

    require 'mtk'

For now, see the specs for examples. Real examples are coming...


## Goals

* Build musical generators to assist with composing music
* Re-implement Cosy (http://compusition.com/web/software/cosy) using these models as the "backend"



## Status

Pre-alpha, API subject to change. Feedback welcome!

My project roadmap is @ https://www.pivotaltracker.com/projects/295419
(it's a bit "fast and loose" right now, but I expect this to get more structured as the project evolves)



## Requirements
### Ruby Version

Ruby 1.8 or 1.9


### Gem Dependencies

* rake (tests & docs)
* rspec (tests)
* yard (docs)
* yard-rspec (docs)
* rdiscount (docs)
* midilib (MIDI file I/O -- not strictly required by core lib, but currently needed for tests)



## Documentation

### Latest:

http://rubydoc.info/github/adamjmurray/mtk/master/frames (may not be fully up-to-date with my latest commits)

### For the gem:

    yard server --gems

then browse to http://localhost:8808

### For github source:

    rake yard

then open doc/frames.html



## Tests

    rake spec

I test with MRI 1.8.7, MRI 1.9.2, JRuby 1.5.6, and JRuby 1.6.2 on OS X via rvm:

    rvm 1.8.7,1.9.2,jruby-1.5.6,jruby-1.6.2 rake spec:fast

