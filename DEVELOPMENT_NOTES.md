MTK
===

[![Build Status](https://secure.travis-ci.org/adamjmurray/mtk.png)](http://travis-ci.org/adamjmurray/mtk)

Music Tool Kit for Ruby
-----------------------

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

[rvm](https://rvm.beginrescueend.com/) is required for cross version testing (see Development Notes below)



Documentation
-------------

Generate with:

     bundle exec rake doc

Or view online @ http://rubydoc.info/github/adamjmurray/mtk/master/frames


Development Notes
-----------------

### Run Tests ###

Test with current version of Ruby:

     bundle exec rake test

Test with all supported versions of Ruby (requires [rvm](https://rvm.beginrescueend.com/), YARV 1.9.3, and JRuby 1.6.7):

     bundle exec rake test:all

The test:all test must pass for a pull request to be accepted or for a release of the mtk gem.


### Generate Docs ###

     bundle exec rake doc
     open doc/frames.html

or, to automatically refresh the documentation as you work:

     bundle exec yard server -r
     open http://localhost:8808


### Release the gems ###

To better handle the differing depdencies between CRuby and JRuby, there are two gems, mtk and jmtk.
You can build both gems with:

     bundle exec gem:build

Do a local sanity check by installing

     # Using CRuby 1.9 or 2.0:
     gem install mtk-0.x.x.gem
     ... test mtk command ...

     rvm use jruby
     jgem install jmtk-0.x.x-java.gem
     ... test jmtk command ...

And then authorized users can push gems to rubygems.org.
