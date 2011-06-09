module MTK::Transform

  # {Collection} that can be reversed
  module Reversible

    # Reverse all elements
    def reverse
      self.class.from_a(to_a.reverse)
    end

    alias retrograde reverse

  end

end
