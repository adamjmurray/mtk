module MTK::Transform

  # {Collection} that supports set theory operations
  module SetTheoryOperations

    def intersection(other)
      self.class.from_a(to_a & other.to_a)
    end

    def union(other)
      self.class.from_a(to_a | other.to_a)
    end

  end

end
