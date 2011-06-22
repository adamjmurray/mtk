MTK
===

Music ToolKit for Ruby
----------------------

Classes for modeling music with a focus on simplicity. Support for reading/writing MIDI files (and soon, realtime MIDI).



Getting Started
---------------

    gem install mtk

or download the source from here and add mtk/lib to your $LOAD_PATH. Then...

    require 'mtk'

For now, see the specs for examples. Real examples are coming...



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

Ruby 1.8+ or JRuby 1.5+


### Dependencies

MTK's core features should not depend on anything outside of the Ruby standard library.

MTK's optional features typically require gems. Currently the following gems are required:

* midilib: required by MTK::MIDI::File for file I/O

Development requires all the gems for optional features, plus the following development tools:

* rake
* rspec (tests)
* yard (docs)
* yard-rspec (docs)
* rdiscount (docs)

[rvm](https://rvm.beginrescueend.com/) is recommended for cross version testing (see Development Notes below)



Documentation
-------------

Gem: http://rdoc.info/gems/mtk/0.0.1/frames

Latest for source: http://rubydoc.info/github/adamjmurray/mtk/master/frames



Development Notes
-----------------

### Run Tests ###

Test with current version of Ruby:

     rake spec

Test with all supported versions of Ruby (requires [rvm](https://rvm.beginrescueend.com/), MRI 1.8.7, MRI 1.9.2, JRuby 1.5.6, and JRuby 1.6.2):

     rake spec:xversion

The spec:xversion test must pass for a pull request to be accepted or for a release of the mtk gem.


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

Notes will start appearing here with the next gem release.