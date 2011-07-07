require 'citrus'
Citrus.load File.join(File.dirname(__FILE__),'mtk_grammar')

module MTK
  module Lang

    # Parser for the {file:lib/mtk/lang/mtk_grammar.citrus MTK grammar}
    class Grammar

      def self.parse(syntax, root=:pitch)
        MTK_Grammar.parse(syntax, :root => root).value
      end

    end

  end
end