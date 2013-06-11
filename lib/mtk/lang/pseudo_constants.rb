module MTK
  module Lang

    # Extension for modules that want to define pseudo-constants (constant-like values with lower-case names)
    module PseudoConstants

      # Define a module method and module function (available both through the module namespace and as a mixin method),
      # to provide a constant with a lower-case name.
      #
      # @param name [Symbol] the name of the pseudo-constant
      # @param value [Object] the value of the pseudo-constant
      # @return [nil]
      def define_constant name, value
        if name[0..0] =~ /[A-Z]/
          const_set name, value # it's just a normal constant
        else
          # the pseudo-constant definition is the combination of a method and module_function:
          define_method(name) { value }
          module_function name
        end
        nil
      end

    end
  end
end
