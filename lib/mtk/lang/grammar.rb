require 'citrus'
Citrus.load File.join(File.dirname(__FILE__),'mtk')

module MTK
  module Lang

    class Grammar

      def self.parse(syntax, root=:pitch)
        MTK_Grammar.parse(syntax, :root => root).value
      end

    end

  end
end