MTK: a Music Tool Kit for Ruby
===

[![Gem Version](https://badge.fury.io/rb/mtk.png)](http://badge.fury.io/rb/mtk) [![Build Status](https://travis-ci.org/adamjmurray/mtk.png?branch=master)](https://travis-ci.org/adamjmurray/mtk) [![Coverage Status](https://coveralls.io/repos/adamjmurray/mtk/badge.png?branch=master)](https://coveralls.io/r/adamjmurray/mtk?branch=master)

MTK is a Ruby library and custom [domain-specific language](https://en.wikipedia.org/wiki/Domain-specific_language) (DSL) for generating musical material.

MTK is flexible: You may use the custom music-generating language without writing any Ruby code, or you may avoid the custom language
 and only program in Ruby, or anywhere in between.


Features
--------

* A minimalist syntax (DSL) for generating musical patterns
* Read and write MIDI files
* Record and output realtime MIDI signals
* Sequence MIDI-compatible event streams
* Manipulate musical objects like pitch, duration, and intensity
* Generate deterministic and non-deterministic music via flexible patterns such as looping sequences and random choices


Getting Started
---------------

MTK works with Ruby 1.9, Ruby 2.0, and JRuby 1.7+.

JRuby is recommended for Windows users.

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

0. Check out examples: https://github.com/adamjmurray/mtk/tree/master/examples

0. Read the [MTK Ruby library documentation](http://rubydoc.info/github/adamjmurray/mtk/master/frames)


Notes on MIDI IO
----------------

I'm also working on a native gem for cross-platform MIDI called 'rtmidi' (which wraps [a C++ library](http://www.music.mcgill.ca/~gary/rtmidi/) of the same name).
If you install this gem via:

    gem install rtmidi

then MTK will use that gem instead of the unimidi gem for MIDI IO on MRI platforms. This resolves a number of issues.
See https://github.com/adamjmurray/ruby-rtmidi for more info and installation instructions.
Future versions of MTK will likely require rtmidi on non-JRuby platforms, so give it a try!


About this project
------------------

This project is developed by [Adam Murray (github.com/adamjmurray)](http://github.com/adamjmurray).

It is a free and open source project licensed under [a permissive BSD-style license](https://raw.github.com/adamjmurray/mtk/master/LICENSE.txt).
I simply ask for credit by including my copyright in derivative works.

You can learn more about the development of this project at the [development notes page](https://github.com/adamjmurray/mtk/blob/master/DEVELOPMENT_NOTES.md).