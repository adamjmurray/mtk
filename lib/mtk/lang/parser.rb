require 'citrus'

# @private
class Citrus::Match
  def values_of(token_name)
    captures[token_name].map{|token| token.value }
  end
end

Citrus.load File.join(File.dirname(__FILE__),'mtk_grammar')

module MTK
  module Lang

    # Parser for the {file:lib/mtk/lang/mtk_grammar.citrus MTK syntax}
    class Parser

      # Parse the given MTK syntax according to the {file:lib/mtk/lang/mtk_grammar.citrus grammar rules}
      # @return [Sequencers::LegatoSequencer] by default
      # @return [Core,Patterns,Sequencers] a core object, pattern or sequencer when an optional grammar rule
      #                                   is given. Depends on the rule.
      # @raise [Citrus::ParseError] for invalid syntax
      def self.parse(syntax, grammar_rule=:root, dump=false)
        syntax = syntax.to_s.strip
        return nil if syntax.empty?
        match = ::MTK_Grammar.parse(syntax, root: grammar_rule)
        puts match.dump if dump
        match.value
      end

    end

  end
end