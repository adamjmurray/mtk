require 'citrus'

class Citrus::Match
  def values(token_name)
    captures[token_name].map{|token| token.value }
  end
end

Citrus.load File.join(File.dirname(__FILE__),'mtk_grammar')

module MTK
  module Lang

    # Parser for the {file:lib/mtk/lang/mtk_grammar.citrus MTK grammar}
    class Grammar

      def self.parse(syntax, root=:timeline)
        syntax = syntax.to_s.strip
        return nil if syntax.empty?
        MTK_Grammar.parse(syntax, :root => root).value
      end

    end

  end
end