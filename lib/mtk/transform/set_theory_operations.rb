module MTK::Transform

  # {Collection} that supports set theory operations
  module SetTheoryOperations

    # the collection of elements present in both sets
    def intersection(other)
      self.class.from_a(to_a & other.to_a)
    end

    # the collection of all elements present in either set
    def union(other)
      self.class.from_a(to_a | other.to_a)
    end

    # the collection of elements from this set with any elements from the other set removed
    def difference(other)
      self.class.from_a(to_a - other.to_a)
    end

    # the collection of elements that are members of exactly one of the sets
    def symmetric_difference(other)
      union(other).difference( intersection(other) )
    end

    # the collection of elements that are not members of this set
    # @note this method requires that the including class define the class method .all(), which returns the collection of all possible elements
    def complement
      self.class.all.difference(self)
    end

  end

end
