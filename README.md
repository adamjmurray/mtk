MTK: a Music Tool Kit for Ruby
===

[![Gem Version](https://badge.fury.io/rb/mtk.png)](http://badge.fury.io/rb/mtk) [![Build Status](https://travis-ci.org/adamjmurray/mtk.png?branch=master)](https://travis-ci.org/adamjmurray/mtk) [![Coverage Status](https://coveralls.io/repos/adamjmurray/mtk/badge.png?branch=master)](https://coveralls.io/r/adamjmurray/mtk?branch=master)

MTK is a Ruby library and custom [domain-specific language](https://en.wikipedia.org/wiki/Domain-specific_language) (DSL) for generating musical material.

MTK is flexible: You may use the custom music-generating language without writing any Ruby code,
or you may avoid the custom language and only program in Ruby, or anywhere in between.


Features
--------

* A minimalist syntax (DSL) for generating musical patterns
* Read and write MIDI files
* Record realtime MIDI input
* Output MIDI in realtime
* Manipulate musical objects like pitch, duration, and intensity
* Generate deterministic and non-deterministic music via flexible patterns such as looping sequences and random choices

Caveat: Want to react to MIDI input and _simultaneously_ generate MIDI output in realtime?
Although it's theoretically possible to make MTK do that, Ruby is not yet well-suited for this kind of CPU bound
concurrent computing, so this library is not currently focused on such efforts.
MTK can record in realtime and separately playback in realtime with "good enough" (not sample-accurate) timing,
but is otherwise intended to manipulate music patterns in non-realtime.

In other words, the realtime IO features are for getting MIDI into and out of the MTK system, and are not intended for
providing an end-to-end realtime music performance environment.

So then, what's the point? This library is intended for two main purposes:

* Generate musical material for use in other music production environments (e.g. [DAWs](https://en.wikipedia.org/wiki/Digital_audio_workstation))
* Enable programmers to explore music theory


Getting Started
---------------

MTK works with Ruby 1.9+, and JRuby 1.7+.

If you are using standard (C-based) Ruby, installation of this gem requires that you are
[setup to compile the rtmidi gem's native dependencies](https://github.com/adamjmurray/ruby-rtmidi/blob/master/README.md#requirements).
If that's problematic for you, use JRuby.

0. Install

        gem install mtk

    Or for JRuby:

        jgem install jmtk

0. Learn the command-line interface:

        mtk --help

    Or for JRuby:

        jmtk --help

0. Learn the MTK syntax with the interactive tutorial by running

        mtk -t

    Or for JRuby

        jmtk -t

0. [Try the Ruby examples](https://github.com/adamjmurray/mtk/tree/master/examples)

0. Read the [MTK Ruby library documentation](http://rubydoc.info/github/adamjmurray/mtk/master/frames)


About this project
------------------

This project is developed by [Adam Murray (github.com/adamjmurray)](http://github.com/adamjmurray).

It is a free and open source project licensed under [a permissive BSD-style license](https://raw.github.com/adamjmurray/mtk/master/LICENSE.txt).
I simply ask for credit by including [my copyright](https://github.com/adamjmurray/mtk/blob/master/LICENSE.txt) in derivative works.


Development Status
------------------

This project is in heavy development and the API and DSL syntax are subject to change.

Active development occurs [in the dev branch](http://github.com/adamjmurray/mtk/tree/dev) and is merged into master
when new gem versions are released.

I manage my task list over in [the pivotal tracker](https://www.pivotaltracker.com/s/projects/295419)
if you want to see what I'm working on and what's planned for the future.

I try to invest in documentation and tutorials, but it is lagging pretty far behind the large amount of
features built thus far. I hope to catch up on that later as things stabilize more.

More info on the [development notes page](https://github.com/adamjmurray/mtk/blob/master/DEVELOPMENT_NOTES.md).


Changelog
---------

Version  | Noteable Changes
-------- | ----------------
0.5      | scales, arpeggios, roman numeral chords (AKA relative chords), sequencer modifiers (skip event, force rest, change octave), changed the foreach syntax, rtmidi gem for realtime I/O
earlier... | too much to list, see version control history and [pivotal tracker](https://www.pivotaltracker.com/s/projects/295419)