MTK: a Music Tool Kit for Ruby
===

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

MTK works with Ruby 1.9, Ruby 2.0, and JRuby 1.7+

0. Install

        gem install mtk

    Or for JRuby:

        jgem install jmtk

0. Learn the command-line interface:

        mtk --help

    Or for JRuby:

        jmtk --help

0. Learn the MTK syntax: TODO... documentation forthcoming. In the meantime, see the unit tests @ https://github.com/adamjmurray/mtk/blob/master/spec/mtk/lang/parser_spec.rb

0. Check out examples: https://github.com/adamjmurray/mtk/tree/master/examples

0. Read the [MTK Ruby library documentation](http://rubydoc.info/github/adamjmurray/mtk/master/frames)


About this project
------------------
This project is developed by [Adam Murray (github.com/adamjmurray)](http://github.com/adamjmurray).

It is a free and open source project licensed under [a permissive BSD-style license](https://raw.github.com/adamjmurray/mtk/master/LICENSE.txt).
I simply ask for credit by including my copyright in derivative works.

You can learn more about the development of this project at the [development notes page](https://github.com/adamjmurray/mtk/blob/master/DEVELOPMENT_NOTES.md).